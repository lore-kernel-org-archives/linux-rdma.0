From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: kitten - mlx4: Unhandled interrupt - owner bit
Date: Wed, 10 Mar 2010 12:00:55 -0800
Message-ID: <ada8wa0kkug.fsf@roland-alpha.cisco.com>
References: <4B97B4BE.1050809@hpce.nec.com>
	<20100310163521.GB18440@mtldesk030.lab.mtl.com>
	<4B97F587.3000209@hpce.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B97F587.3000209-e+cCxrzAqRFWk0Htik3J/w@public.gmane.org> (Fredrik Unger's message of "Wed,
	10 Mar 2010 20:39:51 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Fredrik Unger <funger-e+cCxrzAqRFWk0Htik3J/w@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > To clarify I checked each of the statements separatly and from what I
 > could gather
 > (eqe->owner & 0x80) was true and
 > (eq->cons_index & eq->nent) false.
 > But true! As I am not sure what each statement hides,
 > I do not know if both should be false or true for the eqe to be
 > returned. Will try to check the cons_index closer.

As the '^' (XOR) implies, they should be the same for the EQE to be
returned.

 > Where could I find out more about owner and cons_index / nent ?

The ConnectX programmer's reference manual is what you need.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
