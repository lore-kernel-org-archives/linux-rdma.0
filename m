From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Name for a new type of QP
Date: Wed, 23 Jun 2010 10:58:57 -0700
Message-ID: <adazkyltyu6.fsf@roland-alpha.cisco.com>
References: <4C21D1AA.8060402@Voltaire.COM>
	<BE2BFE91933D1B4089447C64486040801E9D892A@irsmsx503.ger.corp.intel.com>
	<7E95F01E94AB484F83061FCFA35B39F868D9D2@exil.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7E95F01E94AB484F83061FCFA35B39F868D9D2-QfUkFaTmzUSUvQqKE/ONIwC/G2K4zDHf@public.gmane.org> (Alex
	Rosenbaum's message of "Wed, 23 Jun 2010 14:03:28 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <Alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > On the other hand, I never fully understood what does IBV_QPT_RAW_ETY
 > stand for? Maybe we should change its name to better represent what the
 > code does.

Picking names for things is not my strongest suit, and I don't have a
very good suggestion, so I'll leave that out.  But on the point above,
RAW_ETY is for the IBA "raw ethertype" special QP type.  And I think it
would probably be a good idea to change the enum from IBV_QPT_RAW_ETY to
something like IBV_QPT_RAW_ETHERTYPE.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
