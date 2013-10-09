From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 4/4] IB/core: extended command: add a common extended
 response header
Date: Wed, 9 Oct 2013 14:33:24 +0300
Message-ID: <52553F04.20906@mellanox.com>
References: <cover.1381177342.git.ydroneaud@opteya.com> <9e111d8215c1fd86b75db17f2c890f0f28e0d076.1381177342.git.ydroneaud@opteya.com> <5253F37C.90508@mellanox.com> <52553050.8050501@mellanox.com> <0d695256ac989e7b1bcccd3a2bfafcbf@meuh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0d695256ac989e7b1bcccd3a2bfafcbf-zgzEX58YAwA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Igor Ivanov <Igor.Ivanov-wN0M4riKYwLQT0dZR+AlfA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09/10/2013 14:29, Yann Droneaud wrote:
> The other solution is reverting the current patches (22878db, 436f2ad, 
> 400dbc9) and continue to work on this subject for 3.13: I've proposed 
> a slightly different scheme, but it share the same spirit. In the same 
> time I feel like we haven't find agreement on what is really 
> needed/wanted. 

The patches were on the list from April 2013, no way we want to revert 
them.We agree to your fixes and now its a matter for the maintainer to 
either accept them or not.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
