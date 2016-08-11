From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 libmlx5] fix err return values to match ibv_post_send
 expectations
Date: Thu, 11 Aug 2016 13:18:42 +0300
Message-ID: <da52b734-92ec-feea-51be-e3d96ea75a59@dev.mellanox.co.il>
References: <20160808173333.GA26622@obsidianresearch.com>
 <1470679455-28911-1-git-send-email-jarod@redhat.com>
 <b3afb94e-529f-38c4-6cdc-071f8ca3301b@dev.mellanox.co.il>
 <20160811040539.GI29760@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160811040539.GI29760-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/11/2016 7:05 AM, Jarod Wilson wrote:
>> Just fixed that with some other minor typos/changes to the commit
>> log, will send it shortly as V3, left you as the Author to give you
>> the credit for.
>>
>> In addition,
>> Both mlx5_post_recv and mlx5_post_srq_recv should be fixed in the
>> same manner, prepared another patch as some candidate fix will send
>> it shortly as well.
>>
>> Once the new candidate patches will pass our regression testing will
>> take them officially into libmlx5.
>
> Works for me, thanks much.
>

Fine, V3 and second patch to fix the recv flow were applied.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
