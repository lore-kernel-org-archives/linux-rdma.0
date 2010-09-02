From: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: Re: install libsdp openib setup
Date: Thu, 2 Sep 2010 15:34:34 +0300
Message-ID: <4C7F99DA.1090701@mellanox.co.il>
References: <1283354621.14487.80.camel@bohr.ornl.gov>
	<1283355558.14487.83.camel@bohr.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283355558.14487.83.camel-TbGF127JXZUcvh0c176lvQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: simmonsja-1Heg1YXhbW8@public.gmane.org
Cc: James A Simmons <uja-1Heg1YXhbW8@public.gmane.org>, OFED <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 It was a mistake to make a linkage between libsdp and the kernel.
I will roll back this constrain - so --with-openib will not be used any more, and duplicate sdp_socket.h in both, libsdp rpm and the kernel.

So, this will make your fix redundant.

Thanks anyway,
Amir


On 09/01/2010 06:39 PM, James A Simmons wrote:
> This patch has the install.pl pass in the default --with-openib=$value
> for libsdp.
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
