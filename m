From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 0/2] Using multi-smps on the wire in libibnetdisc
Date: Sat, 10 Apr 2010 03:52:45 +0300
Message-ID: <20100410005245.GH4808@me>
References: <20100218124931.4d6ef34b.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100218124931.4d6ef34b.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12:49 Thu 18 Feb     , Ira Weiny wrote:
> After the discussion with Hal I decided it would be safer to just limit the number of outstanding MAD's to 2.  This v3 version changes that.

I don't think that diagnostic tools (something used for investigations)
should have "less" priority then regular program like OpenSM, but
doesn't matter - number 'X' is fine to begin with.

> Patch 2/2 remains the same but I am just sending it to be complete.

I'm applying the whole series with few additions (will post here) - this
is a good start.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
