From: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-rc V1 0/4] RXE fixes for 4.8
Date: Wed, 14 Sep 2016 09:06:52 -0600
Message-ID: <20160914150652.GA7129@cgy1-donard.priv.deltatee.com>
Reply-To: 1473246247-16536-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Hi Doug,

> Please find the following four patches from Yonatan which
> fix numerous issues in RXE code.

Hi

Can I ask as to the status of these patches? I found they stabilized
my RXE test environment a lot. I went from being unable to complete a
run of

ib_write_bw -a -b -d rxe1

due to stalling of network traffic to successful completion of the same
command across all packet sizes with only a stack depth warning of the
form:

[ 1315.810430] kworker/dying (14) used greatest stack depth: 12736 bytes left

So I would like to see some version of this patchset make it into the
codebase soon.

FYI my test configuration is a QEMU socket based network connection
between two QEMU instances running on a bare-metal machine. Running
4.8-rc6 with these three patches applied. For more information on my
test setup see the NVMf over Soft RoCE section of the README.md in [1].

[1] https://github.com/sbates130272/qemu-minimal

For the series:

Tested-by: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>

Cheers

Stephen Bates
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
