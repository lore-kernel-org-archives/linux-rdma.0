From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 1/6] IB/uverbs: Allow CQ moderation with
 modify CQ
Date: Wed, 1 Nov 2017 20:41:30 +0200
Message-ID: <3aca8fdd-7f87-66db-f931-86c941c9a12d@dev.mellanox.co.il>
References: <20171029182808.GN16127@mtr-leonro.local>
 <20171030144807.GA12392@ziepe.ca> <20171030152815.GA16127@mtr-leonro.local>
 <20171030155236.GC12392@ziepe.ca> <20171030190952.GC16127@mtr-leonro.local>
 <20171030230753.GB4081@ziepe.ca> <20171031050802.GE16127@mtr-leonro.local>
 <13d687d9-80b4-621e-87bf-c6045da98c0c@dev.mellanox.co.il>
 <20171031154046.GB9852@ziepe.ca>
 <6e7e94e2-9b50-bfa4-a06a-b2452e1bc8a5@dev.mellanox.co.il>
 <20171101180616.GI1030@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171101180616.GI1030-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/1/2017 8:06 PM, Jason Gunthorpe wrote:
> On Tue, Oct 31, 2017 at 07:06:05PM +0200, Yishai Hadas wrote:
> 
>> The above argument could be issued also on SRQ/WQ which are not expected to
>> be changed in a high rate but uses the attr_mask notation with one system
>> call.
> 
> Yep, those perhaps should not have used the attr_mask scheme either
> 

But they have it as this is current spirit in verbs.

>> As this is currently the spirit of modify_xxx verbs in both user and kernel,
>> we may stay with that and consider this change for verbs2.0 all around when
>> it will come.
> 
> Well, there seem to be quite a lot of new API proposals now, and
> stuffing each of them through some goofy comp_mask or attr_mask thing
> seems like it is going to create a huge complex mess..

I don't agree to above statement, attr_mask is well defined and easy to 
be used in modify_xxx verbs. It can clearly mark which attributes are 
going to be modified similar to some flags attribute.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
