From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH 1/4] IB/isert: properly type the login buffer
Date: Tue, 16 Feb 2016 08:47:12 +0200
Message-ID: <CAJ3xEMizSPkgD4jhZiYD2s33AoY1i0R6P7uCTYwTFvpr1k50Dg@mail.gmail.com>
References: <1455567060-18381-1-git-send-email-hch@lst.de>
	<1455567060-18381-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1455567060-18381-2-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 15, 2016 at 10:10 PM, Christoph Hellwig <hch@lst.de> wrote:
> and separate the request and the response separately, as it's not in a
> performance critical path anyway.

We have simple conventions for iser driver commits, can you please follow them.

The 1st word of the subject to start with Capital letter (e.g
s/properly/Properly/)

Also, "and XXX" isn't how we want sentences to begin in change-logs,
no reason to run anywhere.
