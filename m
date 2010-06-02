From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibverbs: Force line-buffering in ibv_asyncwatch
Date: Wed, 02 Jun 2010 10:05:56 -0700
Message-ID: <ada7hmhtle3.fsf@roland-alpha.cisco.com>
References: <ED0695A5-CBE3-4CE2-A20C-BBC7BEF28C33@Sun.com>
	<e2e108261001210618p476ed03bofa2e46c223578e1a@mail.gmail.com>
	<C25CCF03-2542-4C8D-9AF4-122DBF56F856@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <C25CCF03-2542-4C8D-9AF4-122DBF56F856-UdXhSnd/wVw@public.gmane.org> (=?utf-8?Q?=22?=
 =?utf-8?Q?H=C3=A5kon?= Bugge"'s
	message of "Thu, 21 Jan 2010 16:01:55 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?utf-8?Q?H=C3=A5kon?= Bugge <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > setlinebuf() is pretty intuitive to understand, compared to setvbuf().

I finally applied this; however in the end I decided to do

	setvbuf(stdout, NULL, _IOLBF, 0);

instead of setlinebuf(), since in the past I've prefered more pedantic
stuff (eg posix_memalign instead of memalign) to the older simpler
traditional functions.  Kind of a trivial issue either way anyway.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
