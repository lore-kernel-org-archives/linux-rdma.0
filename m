From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/3] IB/hfi1,core: Driver updates for 12/22/2017
Date: Wed, 3 Jan 2018 10:13:19 -0500
Message-ID: <2517cf89-211d-0f40-17e5-eae670ff429e@intel.com>
References: <20171222164036.29731.43475.stgit@scvm10.sc.intel.com>
 <20171222233738.GB17198@ziepe.ca> <20171225104615.GH2942@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171225104615.GH2942-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/25/2017 5:46 AM, Leon Romanovsky wrote:
> On Fri, Dec 22, 2017 at 04:37:38PM -0700, Jason Gunthorpe wrote:
>> On Fri, Dec 22, 2017 at 08:45:35AM -0800, Dennis Dalessandro wrote:
>>> Don Hiatt (2):
>>>        IB/core: Use rdma_cap_opa_mad to check for OPA
>>>        IB/hfi1: Change slid arg in ingress_pkey_table_fail to 32bit
>>
>> For now I took these two to for-next the other should sit on the list
>> for a bit.
> 
> Just to emphasize how easy to add new field in nldev:

Agree. I'm going to look into that when I can. For now, the patch is 
minor and adds something important for debugging. I've made folks aware 
internally this is the last patch like this, so I'd like to see this go 
in for the current cycle and then we'll get to work on the new 
implementation. Does that sound reasonable?

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
