From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: infiniband limit of 32 cards per system?
Date: Mon, 25 Jan 2010 20:03:58 -0800
Message-ID: <adaaaw1pl5d.fsf@roland-alpha.cisco.com>
References: <20100125235013.GD2828@grease.ALLEYCAT>
	<adaiqapplv7.fsf@roland-alpha.cisco.com>
	<20100126035906.GA23347@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100126035906.GA23347-e+Ta4ugHZmL3oGB3hsPCZA@public.gmane.org> (Alex Chiang's message of
	"Mon, 25 Jan 2010 20:59:06 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, justin.chen-VXdhtT5mjnY@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > I'm guessing that it's not just a simple kernel fix though since
 > OFED has to change too, right?

Dunno about OFED.  Nothing sane is hard-coding major/minor numbers
though -- so I think OFED should be OK, asuming there are no crazy
scripts that bypass udev creating device nodes etc.

I don't think that it's _totally_ trivial in the kernel -- we do need to
add some code in several places to allocate dynamic device numbers when
we run out of the static allocation (probably best to keep the legacy
device numbers for "small" < 32 adapter systems, since there may be
really small systems with static hard-coded /dev etc).

 - R.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
