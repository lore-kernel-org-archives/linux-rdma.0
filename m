From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: ???perftest installation fail???
Date: Mon, 30 Oct 2017 18:34:48 +0800
Message-ID: <246e66d0-198f-566b-2ed5-08182065b12f@huawei.com>
References: <828b3edb-a66b-6118-04a1-6f3624359271@huawei.com>
 <20171028230854.GA26223@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171028230854.GA26223-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ÔÚ 2017/10/29 7:09, Jason Gunthorpe Ð´µÀ:
> On Fri, Oct 27, 2017 at 04:05:10PM +0800, oulijun wrote:
>> Hi, Benjamin Drung
>>   I am using the perftest and happen a fail when configured.
>>
>> checking for ibv_get_device_list in -libverbs... yes
>> checking for rdma_create_event_channel in -lrdmacm... no
>> configure: error: librdmacm-devel not found
> 
> When you are cross-compiling you will need to install the verbs and
> other rdma-core libraries into your cross compilation paths before you
> can compile perftest.
> 
> Jason
> 
> 
Thanks. I am trying to install OFED and maybe include it.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
