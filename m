From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH libibverbs] Fix configure regression that disallowed building
 on older systems
Date: Thu, 11 Jul 2013 15:01:09 +0300
Message-ID: <51DE9E85.8000301@mellanox.com>
References: <1373538859-32636-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx> <b582a3bf3c6471398d45322cc7f11d34@meuh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b582a3bf3c6471398d45322cc7f11d34-zgzEX58YAwA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/07/2013 14:03, Yann Droneaud wrote:
> If the "release" tarball is used, the library should build regardless
> of the installed autoconf/automake.
indeed, but when we d/d (develop/debug) with the library we should be 
able to build it through simple configure and make
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
