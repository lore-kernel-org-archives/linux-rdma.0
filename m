From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH v3 0/2] Using multi-smps on the wire in libibnetdisc
Date: Fri, 2 Apr 2010 17:23:30 -0700
Message-ID: <20100402172330.819b8ef6.weiny2@llnl.gov>
References: <20100218124931.4d6ef34b.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100218124931.4d6ef34b.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha,

Have you had a chance to look at this yet?  If you want I can resend the latest version of the patches.

Thanks,
Ira

On Thu, 18 Feb 2010 12:49:31 -0800
Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org> wrote:

> After the discussion with Hal I decided it would be safer to just limit the number of outstanding MAD's to 2.  This v3 version changes that.  Patch 2/2 remains the same but I am just sending it to be complete.
> 
> Thanks,
> Ira
> 


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
