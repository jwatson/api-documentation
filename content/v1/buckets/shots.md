---
title: Buckets - Shots | Dribbble API
---

# Shots

* TOC
{:toc}

## List shots for a bucket

    GET /bucket/:id/shots

### Response

<%= headers 200 %>
<%= json(:shot) { |hash| [hash] } %>