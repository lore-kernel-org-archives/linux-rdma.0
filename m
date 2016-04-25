From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 11/11] IB/srp: Prevent mapping failures
Date: Mon, 25 Apr 2016 12:46:59 +0300
Message-ID: <571DE793.6090705@grimberg.me>
References: <571A936F.7040409@sandisk.com> <571A94AF.7000609@sandisk.com>
 <20160424083538.GF7974@leon.nu> <571D6975.2020905@sandisk.com>
 <20160425055433.GG7974@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160425055433.GG7974-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>>> +		max_max_sectors = (srp_dev->max_pages_per_mr - 1) <<
>>>> +				  (ilog2(srp_dev->mr_page_size) - 9);
>>>
>>>  From my understanding, srp_dev->max_pages_per_mr can be equal to 1, in
>>> case device will advertise it.
>>>
>>> Is this understanding correct?
>>> Will the code work in such case?
>>
>> Hello Leon,
>>
>> I'm not sure a HCA driver exists for which max_pages_per_mr == 1.
>> Additionally, I'm not sure such a driver would be useful because such a
>> driver would limit the maximum data transfer size for the iSER protocol to 4
>> KB. That is too low to reach good performance.
>
> Bart and Laurence,
> You are raising valuable arguments about sanity of setting srp_dev->max_pages_per_mr
> to be equal 1. I totally agree with you that it is insane, however my
> original question was "does the code support such value?"

I don't see why we should worry about imaginary devices.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
