From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Conflict installing rdma-core PPA on Ubuntu Bionic
Date: Sun, 14 Jan 2018 16:02:13 +0200
Message-ID: <bc5c6316-58b5-a57d-2cae-b022e4ce2b00@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <bdrung-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I tried using the linux-rdma PPA package for Ubuntu Bionic (18.04), and 
it turns out both the rdma-core package (version 
17.0~201801091117+gitc434578~ubuntu18.04.1) and the kmod package 
(version 24-1ubuntu2) provide the file /etc/modprobe.d/mlx4.conf.

I'm not sure whether or not it is an issue with the Ubuntu kmod package 
or with the PPA package.

Regards,
Haggai


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
