From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [infiniband-diags] [PATCH] remove obsoleted option from
 iblinkinfo manpage
Date: Sun, 13 Dec 2009 22:22:14 +0200
Message-ID: <20091213202214.GS5262@me>
References: <1260473918.4557.97.camel@auk31.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1260473918.4557.97.camel-X2zTWyBD0EhliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Al,

On 11:38 Thu 10 Dec     , Al Chu wrote:
> 
> Nothing fancy, noticed the manpage still had this obsoleted option
> listed.  I copied the documentation that was put into the ibqueryerrors
> manpage.
> 
> Al
> 
> -- 
> Albert Chu
> chu11-i2BcT+NCU+M@public.gmane.org
> Computer Scientist
> High Performance Systems Division
> Lawrence Livermore National Laboratory

> From e0050396ddd4cbd611abef3ac74fca854c038b12 Mon Sep 17 00:00:00 2001

Please don't add such '\n^From ' line to patch change log. It is used as
email message separator in mbox format. As result many git related tools
(such as 'git rebase') will be confused by this.

For more details about desired patch/email format you can see:

	/usr/src/linux/Documentation/SubmittingPatches

> From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> Date: Thu, 10 Dec 2009 11:25:22 -0800
> Subject: [PATCH] remove obsoleted option from iblinkinfo manpage
> 
> 
> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>

Applied.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
