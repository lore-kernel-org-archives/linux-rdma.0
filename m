From: Roland Dreier <roland@kernel.org>
Subject: Re: linux-next: build failure after merge of the infiniband tree
Date: Mon, 15 Dec 2014 18:22:13 -0800
Message-ID: <CAG4TOxMerrp0wHZ=cA-29iDvnZ8HsdqTb_1ftCFB7XHu70_iZg@mail.gmail.com>
References: <20141216124750.153e3fdd@canb.auug.org.au> <CAG4TOxP9WFHALPb0y0eKFup6uhszXfd+hLcwZ98kZUVaR_9j4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <CAG4TOxP9WFHALPb0y0eKFup6uhszXfd+hLcwZ98kZUVaR_9j4w@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Haggai Eran <haggaie@mellanox.com>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 15, 2014 at 5:56 PM, Roland Dreier <roland@kernel.org> wrote:
> I'll add a partial revert of that patch to my tree to get back the
> now-used enum values.

I rebased my tree on top of the merge-window merge of davem's tree,
and added the missing flag on top of the "remove this flag" commit.

 - R.
