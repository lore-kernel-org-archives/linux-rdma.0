From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/5 for rdma-core] Five rxe_cfg patches
Date: Fri, 7 Oct 2016 11:37:43 -0700
Message-ID: <bf5dba39-7e14-23ee-4aa1-2a276d629fe9@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Doug, Jason and Moni,

These five patches is what I came up with after having had a look at the 
rxe_cfg source code. It would be appreciated if these patches would be 
considered for inclusion in the rdma-core repository. The filenames of 
these patches are:

0001-rxe_cfg-Use-Perl-functions-instead-of-parsing-the-ou.patch
0002-rxe_cfg-Initialize-rxe_mtu-even-if-ibv_definfo-fails.patch
0003-rxe_cfg-Do-not-suppress-stderr.patch
0004-rxe_cfg-Remove-dead-code-from-show_module_status.patch
0005-rxe_cfg-Use-printf-instead-of-using-a-loop.patch

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
