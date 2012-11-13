From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/1] ib_srp: Infiniband srp fast failover patch.
Date: Tue, 13 Nov 2012 23:07:33 +0200
Message-ID: <CAJZOPZJC=ojRuczvPGE1WSWZNWz59DGt8YGAQrUj9AfwfY2vAA@mail.gmail.com>
References: <4FC53AAA.3060203@ddn.com>
	<1338354377.2361.13.camel@obelisk.thedillows.org>
	<CAJZOPZL0cj6Sb_xs7prV0k8HjWkELD7Y89Bxxp-xXnnGqxvXyg@mail.gmail.com>
	<50A18A3D.9070304@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50A18A3D.9070304-LfVdkaOWEx8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Karandeep Chahal <kchahal-LfVdkaOWEx8@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 13, 2012 at 1:46 AM, Karandeep Chahal <kchahal-LfVdkaOWEx8@public.gmane.org> wrote:
> In my experience with ib-srp, I am not sure if there is such a thing as link
> going down for a short time. When the link goes down, no matter how short
> the duration (< 1s), IO fails over, this failover takes very long time currently.

But maybe IOs fail over since these patches force them to be (e.g disconnected
the IB RC connection and remove the related SCSI host), even if the RC
connection
can survive this small link down event?

>  Or, I would like to know if you can get a ib-srp failover time of
> less than a minute somehow (by tweaking OS or multipath settings). I was
> unable to get it to work even after a pretty exhaustive attempt.

looking on this
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
