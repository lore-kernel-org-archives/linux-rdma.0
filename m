From: Roland Dreier <roland@purestorage.com>
Subject: Re: [PATCH 00/11] First pass at merging Bart's HA work
Date: Thu, 29 Nov 2012 12:21:20 -0800
Message-ID: <CAL1RGDXpdWL_r7sWp=vvvXH4jxFgjDL+XcEGgKo-44=wrOBmtA@mail.gmail.com>
References: <cover.1353903448.git.dillowda@ornl.gov> <CAL1RGDU+b4GxEoY0TOvkyJjr0yx=5tFNmAVZ27hVjOOx=n=yJg@mail.gmail.com>
 <1353957308.2681.5.camel@dabdike> <1353989041.28917.24.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1353989041.28917.24.camel@obelisk.thedillows.org>
Sender: linux-scsi-owner@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>, fujita.tomonori@lab.ntt.co.jp, rcj@linux.vnet.ibm.com
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 26, 2012 at 8:04 PM, David Dillow <dillowda@ornl.gov> wrote:
> We can push it through James's tree if need be, but Bart's code is
> pretty self-contained, and going through the SCSI tree will introduce
> merge dependencies. It'd be much easier to push it all through the RDMA
> tree, especially if we want to get this landed for 3.8.

OK, I guess all the srp_transport stuff looks quite simple and good to
me, so I'm OK merging it.

Is there some subset of patches that you and Bart agree are good,
which I can pick up now?  I'd love to get at least some of the SRP
stuff into 3.8, and that window is opening pretty soon.
