From: Marta Rybczynska <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Subject: [nvme-fabrics]Fabrics over ROCEv2
Date: Thu, 23 Jun 2016 15:38:29 +0200 (CEST)
Message-ID: <1755342088.51635051.1466689109109.JavaMail.zimbra@kalray.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,
I'm doing some interoperability tests with NVMEoF in different configurations.
I have problems setting up Mellanox ConnectX-3 Pro to perform NVMEoF in RoCE v2 mode.

I have limited the set up to 2 Mellanox cards:
* if they are connected by a cable directly it works fine, I can set up a NVMEoF
and access the disk just right. It uses ROCEv1

* if they are connected by a router (in fact a 3rd machine with different 40Gbit
cards) the discover/connect operations do not work. In the packet trace I can see
that 1st card has sent an UDP packet that looks right, but the second system
answers with ICMP port unreachable.

Has anyone tried a setup in ROCEv2 mode?

Thanks in advance,


-- 

Marta Rybczynska 

Phone : +33 6 71 09 68 03 
mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
