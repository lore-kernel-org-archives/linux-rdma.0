From: ib-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org
Subject: Re: perftest question
Date: Tue, 17 May 2011 13:53:06 -0600
Message-ID: <20110517135306.zxkyatjh2oows8co@celticblues.com>
References: <20110517131910.3dw9cgbfj4ck04cw@celticblues.com>
	<4DD2CF58.5080806@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DD2CF58.5080806-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Ok.  Thanks for the information.

Is there any particular advantage of using CM over TCP for this  
information (LID or GID, Qp num, PSN, RKey and the address of the  
writing buffer)?

Is ib_write_bw an example of RDMA write / RD?

E


Quoting Ido Shamai <idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>:

> Those are actually the same tests, from an IB point of view.
>
> the difference between them is that ib_write_bw passes the arguments
> that need to be known to other side ( LID or GID, Qp num, PSN, RKey and
> the address of the writing buffer) before post_sending,
>
> through TCP connection (using sockets) and the rdma_bw uses the rdma_cm
> module , which sends those arguments through the IB wire and the SM.
>
> rdma_cm is not updated with all the features ib_write_bw have. I will
> work on this test shortly
>
> Ido
>
>
> On 5/17/2011 10:19 PM, ib-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org wrote:
>> Just downloaded a snapshot of the perftests.  In the README under   
>> "Test Descriptions" it says:
>>
>> rdma_bw.c     streaming BW test with RDMA write transactions
>>
>> and
>>
>> write_bw.c     BW test with RDMA write transactions
>>
>> What is the difference between rdma_bw and write_bw?  I see that   
>> the rdma_bw description contains "streaming" where as write_bw   
>> description does not...  but I am not sure I understand what that   
>> means?
>>
>> E
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
