# React Performance: Lab Scores vs. Production Reality

## Overview

React performance measurement has split into two camps that often disagree. "Lab" tools —
React DevTools Profiler, Lighthouse, Chrome DevTools Performance panel — run in a controlled,
single-run, synthetic environment. They're great for catching regressions in development because
conditions are fixed and repeatable, but they cannot see real device variability, network jitter, or
actual user interaction. Lighthouse specifically cannot even measure INP (Interaction to Next Paint)
because there's no real interaction in a simulated run. "Field" data — Real User Monitoring (RUM),
Chrome's CrUX dataset — captures what actually happens on real users' devices and networks, and
is the only way to see the full distribution of experience (p50 vs p95 users on a budget Android
phone on 3G look nothing like your dev laptop). The current industry consensus (Google's own
web.dev guidance, and RUM vendors like Dynatrace) is that you need both: lab for fast regression
catching pre-merge, field/RUM for ground truth on what users actually experience. Core Web Vitals
(LCP ≤2.5s, INP ≤200ms, CLS ≤0.1) are the shared vocabulary both sides report against.

## The session

**[1429] From Profiler to Production: Measuring What Actually Matters in React & React Native**
— Andrei Tazetdinov, Senior Software Engineer & Tech Evangelist, Dynatrace. Wed 25 Nov,
13:30-14:00, Stage 1 (IBM-powered).

Teaser: "Every React developer knows how to open DevTools. Far fewer know which numbers to
trust — and which ones are lying to you. Lighthouse scores look great in reports but don't always
correlate with real..." Given the speaker is from Dynatrace (a RUM/observability vendor), expect the
talk's core argument to be: stop trusting a single lab score as a proxy for real user experience;
instrument production and profile against real interaction data, then use the Profiler/Lighthouse
locally only to chase down root cause once RUM tells you where it hurts. Likely covers React DevTools
Profiler flame charts, React Native-specific metrics (TTI, JS thread vs. UI thread), and probably a
pitch for synthetic + RUM correlation as the fix for "my Lighthouse score is 95 but users complain."

## Key concepts to know going in

- **LCP / INP / CLS** — the three Core Web Vitals; INP replaced FID in 2024 as the responsiveness metric.
- **Lab vs. field data** — Lighthouse/DevTools (lab, single synthetic run) vs. CrUX/RUM (field, real users).
- **React DevTools Profiler** — flame graphs showing commit/render cost per component.
- **Re-render cost vs. mount cost** — a common React-specific trap Lighthouse doesn't separate well.
- **RUM (Real User Monitoring)** — instrumentation that reports actual user-session timing data, not simulated runs.

## Connects to your work

You already run Splunk RUM on the Cisco reporting UIs (Connectivity Logs, Events Correlation,
Activity Search, DNS Security Reporting), built in React/Redux/Redux-Saga/React Query. That puts
you ahead of most of the room — you already have field data, not just lab scores. Three things worth
comparing against what the talk recommends:

1. Whether your current Redux-Saga + React Query combination is double-fetching or double-subscribing in ways that only show up in Profiler commit counts, not in Splunk RUM's page-level timings.
2. Whether you're correlating Splunk RUM INP/LCP regressions back to specific component commits via the Profiler, or only reacting to aggregate dashboards after the fact.
3. Whether CSV export and drilldown interactions (large-table re-renders) are being measured as "interactions" in your RUM setup at all, or just page loads.

A sharp question for the Q&A: "With Redux-Saga driving most state transitions in our reporting
screens, where does React Query's cache invalidation mess with RUM's INP attribution — do you
see false positives from library-driven re-renders that users never notice?"

Sources: web.dev Core Web Vitals (web.dev/articles/vitals), Dynatrace RUM vs. synthetic monitoring blog.
