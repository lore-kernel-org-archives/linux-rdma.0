From: Steven Dake <sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] change thread-unsafe readdir to thread-safe readdir_r
 calls
Date: Wed, 21 Jul 2010 11:33:53 -0700
Message-ID: <4C473D91.8000704@redhat.com>
References: <1278540873-3857-1-git-send-email-sdake@redhat.com> <adak4ooogjj.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adak4ooogjj.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07/21/2010 11:06 AM, Roland Dreier wrote:
>   >  +	buf = alloca(offsetof(struct dirent, d_name) + NAME_MAX + 1);
>   >  +	while (readdir_r(class_dir, buf,&dent) == 0&&  dent) {
>
> So after thinking this over, I don't think I'm going to apply this
> patch.  I think the right fix is for corosync to allow readdir() -- in
> general pushing people to safer APIs is probably a good thing, but I
> think in this particular case it doesn't make sense.  In fact it seems
> that readdir_r() is actually worse since the "buf" parameter does not
> have a well-defined required size, while readdir() is actually safe in
> most uses.
>
>   - R.

thanks for considering

regards
-steve
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
