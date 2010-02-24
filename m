From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ewg] nfsrdma fails to write big file,
Date: Wed, 24 Feb 2010 11:06:13 -0800
Message-ID: <ada3a0q1mje.fsf@roland-alpha.cisco.com>
References: <9FA59C95FFCBB34EA5E42C1A8573784F02662E58@mtiexch01.mti.com>
	<4B82D1B4.2030902@opengridcomputing.com>
	<9FA59C95FFCBB34EA5E42C1A8573784F02662EA8@mtiexch01.mti.com>
	<9FA59C95FFCBB34EA5E42C1A8573784F02663166@mtiexch01.mti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9FA59C95FFCBB34EA5E42C1A8573784F02663166-SDnKeQl2TTymvrjiD8yIlgC/G2K4zDHf@public.gmane.org> (Vu
	Pham's message of "Wed, 24 Feb 2010 10:56:09 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mahesh Siddheshwar <siddheshwar.mahesh-xsfywfwIY+M@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > +               /* 
 > +                * Add room for frmr register and invalidate WRs
 > +                * Requests sometimes have two chunks, each chunk
 > +                * requires to have different frmr. The safest
 > +                * WRs required are max_send_wr * 6; however, we
 > +                * get send completions and poll fast enough, it
 > +                * is pretty safe to have max_send_wr * 4. 
 > +                */
 > +               ep->rep_attr.cap.max_send_wr *= 4;

Seems like a bad design if there is a possibility of work queue
overflow; if you're counting on events occurring in a particular order
or completions being handled "fast enough", then your design is going to
fail in some high load situations, which I don't think you want.

 - R.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
