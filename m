From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V2 4/5] IB/mlx5: Add hca_core_clock_offset to
 udata in init_ucontext
Date: Wed, 23 Dec 2015 11:58:30 +0200
Message-ID: <CAAKD3BDah__b9BSYG0r5cAdv8a7XR99nSnVFjb8RF=zy8VOf6g@mail.gmail.com>
References: <1450204213-5630-1-git-send-email-matanb@mellanox.com>
	<1450204213-5630-5-git-send-email-matanb@mellanox.com>
	<CAJ3xEMguJeQnrHAM9WCXZf+NyNOwBGCfpka5ywUtfLHT1wL3ig@mail.gmail.com>
	<567A6370.1030008@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <567A6370.1030008-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 23, 2015 at 11:03 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 12/22/2015 11:37 PM, Or Gerlitz wrote:
>>
>> On Tue, Dec 15, 2015 at 8:30 PM, Matan Barak<matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>  wrote:
>>>
>>> >Pass hca_core_clock_offset to user-space is mandatory in order to
>>> >let the user-space read the free-running clock register from the
>>> >right offset in the memory mapped page.
>>> >Passing this value is done by changing the vendor's command
>>> >and response of init_ucontext to be in extensible form.
>>
>> Is "old" (unpatched) libmlx5 still operational over "new" (patched)
>> mlx5 IB driver?
>
>
> and same question for the other way around as well
>

new kernel, old lib - response length is initialized to
min(offsetof(typeof(resp), response_length) +
sizeof(resp.response_length), udata->outlen);
I this case, we initialize it to udata->outlen, so the user-space gets
exactly the same information as before.

new lib, old kernel - the response is cleared before it is sent to the
kernel. The command size has stayed the same.
So - (reqlen == sizeof(struct mlx5_ib_alloc_ucontext_req_v2)) still holds true.
Since the kernel isn't familiar with the new response fields, it
doesn't copy them. Hence the response's comp_mask is still zero and
libmlx5 knows that hca_core_clock isn't supported.

Matan

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
