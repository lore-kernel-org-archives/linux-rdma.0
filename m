From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB: Refactor umem to use linear SG table
Date: Mon, 3 Feb 2014 20:38:40 +0200
Message-ID: <CAJZOPZLf7VZiDE655EBWK3uMS=t_N1vsX7B5KuMme7MRWFku5w@mail.gmail.com>
References: <1390909215-5331-1-git-send-email-ogerlitz@mellanox.com>
	<52E7AA22.8020700@mellanox.com>
	<1F4FC384-349B-4F37-B06E-214A0B8570DE@cisco.com>
	<6B2A6E60C06CCC42AE31809BF572352B8CF3AC3B@MTLDAG02.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6B2A6E60C06CCC42AE31809BF572352B8CF3AC3B-LSMZvP3E4uyuSA5JZHE7gA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 3, 2014, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> From: Upinder Malhi (umalhi) [mailto:umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org]

>> Any particular reason that the code in usNIC that walks the chunk sg's isn't
>> ported to the linear SG table?

> As your code didn't use the API which we changed, we preferred avoiding changing
> it, to avoid introducing issues into the code, especially when we don't have the
> needed hardware to test your code on.

Indeed, thanks Shachar for stressing this point

> You are more than welcome to implement a similar change in your code, or port
> your code to use the ib_umem_get API.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
