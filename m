From: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
Subject: Re: infiniband limit of 32 cards per system?
Date: Tue, 26 Jan 2010 14:38:03 -0700
Message-ID: <20100126213803.GA12035@ldl.fc.hp.com>
References: <20100125235013.GD2828@grease.ALLEYCAT> <adaiqapplv7.fsf@roland-alpha.cisco.com> <20100126035906.GA23347@ldl.fc.hp.com> <adaaaw1pl5d.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adaaaw1pl5d.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, justin.chen-VXdhtT5mjnY@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

* Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>:
> 
>  > I'm guessing that it's not just a simple kernel fix though since
>  > OFED has to change too, right?
> 
> Dunno about OFED.  Nothing sane is hard-coding major/minor numbers
> though -- so I think OFED should be OK, asuming there are no crazy
> scripts that bypass udev creating device nodes etc.

Ok.

> I don't think that it's _totally_ trivial in the kernel -- we
> do need to add some code in several places to allocate dynamic
> device numbers when we run out of the static allocation
> (probably best to keep the legacy device numbers for "small" <
> 32 adapter systems, since there may be really small systems
> with static hard-coded /dev etc).

I take it this concern is what prevents us from simply increasing
IB_UVERBS_MAX_DEVICES to 64 or something?

thanks,
/ac
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
