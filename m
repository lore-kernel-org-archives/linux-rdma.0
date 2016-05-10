From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: generic RDMA READ/WRITE API V8
Date: Tue, 10 May 2016 10:29:38 -0700
Message-ID: <57321A82.5090309@sandisk.com>
References: <1462291273-22403-1-git-send-email-hch@lst.de>
 <9b8601d1aae1$15f13d70$41d3b850$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9b8601d1aae1$15f13d70$41d3b850$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/10/2016 10:26 AM, Steve Wise wrote:
>>
>> This series contains patches that implement a first version of a gen=
eric
>> API to handle RDMA READ/WRITE operations as commonly used on the tar=
get
>> (or server) side for storage protocols.
>>
>> This has been developed for the upcoming NVMe over Fabrics target, a=
nd
>> extensively te=D1=95ted as part of that, although this upstream vers=
ion has
>> additional updates over the one we're currently using.
>>
>> It hides details such as the use of MRs for iWarp devices, and will =
allow
>> looking at other HCA specifics easily in the future.
>>
>> This series contains also conversion the SRP and iSER targets to the=
 new
>> API.
>>
>> I think it's basically ready to merge now.
>>
>> I also have a git tree available at:
>>
>> 	git://git.infradead.org/users/hch/rdma.git rdma-rw-api
>>
>> gitweb:
>>
>> 	http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/rdm=
a-rw-
>> api
>>
>
> Hey Doug,
>
> Is this on your to-do list for 4.7?  I think it is ready to
 > merge.  But I don't see it in your k.o/for-4.7 branch yet.

BTW, the SRP patches I'm working on will need the ib_map_mr_sg() change=
s=20
from this patch series.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
