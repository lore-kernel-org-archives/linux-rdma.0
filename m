From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V2 4/5] IB/mlx5: Add hca_core_clock_offset to
 udata in init_ucontext
Date: Wed, 23 Dec 2015 11:03:44 +0200
Message-ID: <567A6370.1030008@mellanox.com>
References: <1450204213-5630-1-git-send-email-matanb@mellanox.com>
 <1450204213-5630-5-git-send-email-matanb@mellanox.com>
 <CAJ3xEMguJeQnrHAM9WCXZf+NyNOwBGCfpka5ywUtfLHT1wL3ig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMguJeQnrHAM9WCXZf+NyNOwBGCfpka5ywUtfLHT1wL3ig-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/22/2015 11:37 PM, Or Gerlitz wrote:
> On Tue, Dec 15, 2015 at 8:30 PM, Matan Barak<matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>  wrote:
>> >Pass hca_core_clock_offset to user-space is mandatory in order to
>> >let the user-space read the free-running clock register from the
>> >right offset in the memory mapped page.
>> >Passing this value is done by changing the vendor's command
>> >and response of init_ucontext to be in extensible form.
> Is "old" (unpatched) libmlx5 still operational over "new" (patched)
> mlx5 IB driver?

and same question for the other way around as well
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
