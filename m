From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 00/13] Demux IB CM requests in the rdma_cm module
Date: Thu, 30 Jul 2015 18:16:19 +0000
Message-ID: <HE1PR05MB1355635D326796B22C74285AC18B0@HE1PR05MB1355.eurprd05.prod.outlook.com>
References: <1438167991-17211-1-git-send-email-haggaie@mellanox.com>
 <55B8E7F6.2030603@redhat.com>
 <55B9E848.6040907@mellanox.com>,<55BA43B9.7050801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55BA43B9.7050801-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thursday, July 30, 2015 6:33 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> To: Haggai Eran
> Cc: Liran Liss; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Jason Gunthorpe
> Subject: Re: [PATCH v3 00/13] Demux IB CM requests in the rdma_cm module
> 
> On 07/30/2015 05:03 AM, Haggai Eran wrote:
>> On 29/07/2015 17:49, Doug Ledford wrote:
>>> This doesn't apply on to a clean 4.2-rc4 kernel tree.  Can you please
>>> rebase against either that or my to-be-rebase/for-4.3 branch of my
>>> github repo?
>>
>> Sure. Keep in mind that this patchset also depends on the patch from
>> Matan's series to protected the device and client list with a rwsem [2].
>> Do you want me to add it to this series?
> 
> You added it to the series, which is OK and I've picked that series up.
>  In general though, if there are two different patch series that both
> need the same patch, I would prefer it if that one patch is sent by
> itself so I can grab it and not included in either of the other two
> series.  I think some of the patches that didn't apply were when I
> forgot to remove a duplicate patch found in two different series.

Okay, I'll do that in the future.

In any case, there was minor conflict between the client context patch and the hot removal patchset, so a rebase was necessary anyway.

Thanks,
Haggai--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
