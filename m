From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-3.14 1/5] IB/mlx4: Make sure GID index 0 is always
 occupied
Date: Wed, 5 Feb 2014 15:52:32 +0200
Message-ID: <52F24220.8000607@mellanox.com>
References: <1391605982-4348-1-git-send-email-ogerlitz@mellanox.com> <1391605982-4348-2-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391605982-4348-2-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/02/2014 15:12, Or Gerlitz wrote:
> From: Moni Shoua<monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
>
> Make sure that for Ethernet ports, the port GID table index 0 is always
> occupied with a default GID of the relevant IPv6 link-local adderss.
>
> This provides better user-experience for legacy applications that don't use
> the rdma-cm and where working on index 0 prior to the IP addressing change.
Roland, I see here small typo "where" instead of "were", care to fix 
that yourself?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
