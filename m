From: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: positive or negative error values from vendor library for immediate
 errors?
Date: Fri, 12 Dec 2014 13:56:31 +0200
Message-ID: <548AD7EF.1030102@gmail.com>
References: <EE7902D3F51F404C82415C4803930ACD51D6475F@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EE7902D3F51F404C82415C4803930ACD51D6475F-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Devesh.

I wish that there was a header that maps the return errors to errno,
to make things much more canonical. But currently we don't have it :(

AFAIK, the guidelines is that kernel code returns negative values
and userspace code should return positive values.

Thanks
Dotan

On 08/12/2014 12:47, Devesh Sharma wrote:
> Hello list,
>
> While reviewing some the vendor library source I found that Mellanox and Pathscale user-space provider library returns positive error number if any immediate error is encountered.
> However, other vendor user-space libraries return negative error numbers.
>
> Is there any guideline on this topic. If not, what is the correct way to do this.
> Taking reference of glibc implementation, I found that it expects negative integer as return value.
>
> Any pointer/reference/guideline will be a great help.
>
> -Regards
>   Devesh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
