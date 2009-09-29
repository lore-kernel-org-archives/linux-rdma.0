From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: Posting Problem
Date: Tue, 29 Sep 2009 23:59:34 +0200
Message-ID: <20090929215934.GB17846@me>
References: <f0e08f230909291053l1062277an21cab3b330a46e09@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230909291053l1062277an21cab3b330a46e09-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 13:53 Tue 29 Sep     , Hal Rosenstock wrote:
> I've been able to post a short test message but when I post a patch,
> it seems to go into the ether. How can I find out what is going wrong
> ?

If it is about this email:

Date: Thu, 24 Sep 2009 15:34:44 -0400
From: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-rdma-2V+nj6dI/Rc/ohRxsw7f2g@public.gmane.org
Subject: [PATCH] ibsim/sim_cmd.c: Only relink port if remote port is
        currently linked

Then there was a wrong address - should be "*.kernel.org" (not
"*.linux.org").

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
