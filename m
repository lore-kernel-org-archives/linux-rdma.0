From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: Question on mlx5-ib auto load
Date: Sun, 24 Sep 2017 22:49:25 +0300
Message-ID: <23e29fc3-408b-1809-97eb-a105ab0e6488@grimberg.me>
References: <daab19a4-98c8-3115-065d-2c40c5843121@grimberg.me>
 <20170924185559.GI25094@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170924185559.GI25094-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> Did anyone notice that mlx5_ib does not auto load at boot time?
>>
>> While mlx5_core requests mlx5_ib, mlx5_ib still does not load
>> at boot time (only when reloading mlx5_core).
>>
>> I noticed it today, and could only get around it by adding
>> mlx5_ib to /etc/modules-load.d/modules.conf
> 
> It is supposed to work automatically without need to add anything
> (except rxe) in the modules-load.d.
> 
>>
>> Is there something I'm missing?
> 
> We had an opposite bug - the removal didn't work.
> https://lkml.org/lkml/2017/9/9/123
> 
> What is your OS, rdma-core version and kernel version?

# cat /etc/os-release
NAME="Ubuntu"
VERSION="16.04 LTS (Xenial Xerus)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 16.04 LTS"
VERSION_ID="16.04"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
UBUNTU_CODENAME=xenial

# uname -a
Linux client 4.14.0-rc1+ #193 SMP Sun Sep 24 11:24:38 IDT 2017 x86_64 
x86_64 x86_64 GNU/Linux

# dpkg -l | grep rdma-core
rc  rdma-core                         14-1 
amd64        RDMA core userspace infrastructure and documentation
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
