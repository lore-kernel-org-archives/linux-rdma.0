From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 4/4] IB/core: extended command: add a common extended
 response header
Date: Wed, 9 Oct 2013 13:30:40 +0300
Message-ID: <52553050.8050501@mellanox.com>
References: <cover.1381177342.git.ydroneaud@opteya.com> <9e111d8215c1fd86b75db17f2c890f0f28e0d076.1381177342.git.ydroneaud@opteya.com> <5253F37C.90508@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5253F37C.90508-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 08/10/2013 14:58, Matan Barak wrote:
> Regarding the last patch, you are right that it simplifies things for 
> creating new uverbs where command parts are in-lined one after 
> another, but the infrastructure got a bit more complex.
>
> If we're going to this direction, I think the we should also deal with 
> the problem of extending one of the command parts. Currently, we'll 
> have to put a comp_mask in the in-lined command part, consume this 
> command part and then continue with the other parts. It might be 
> better than using a pointer, but this put the burden of serializing 
> the command buffer into the kernel structures onto the uverb command 
> writer. We might want to avoid this.
>
> Furthermore, the comp_mask of the command is different than the 
> comp_mask of the response. Therefore, I don't think we should pass the 
> command's comp_mask to the uverb as a pointer, but just pass a pointer 
> to value 0 that the uverb will set. 

Guys, sounds to me it's a bit too late for patch #4 -- we have to leave 
something for the next generation to work on... we're after rc4 and we 
don't want to let 3.12 have different uverbs API vs future kernel just 
for the sake of fixing the issues Yan pointed on. I suggest that patches 
1-3 will go into 3.12 - Roland, are you willing to pick this up? We have 
Matan's ack.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
