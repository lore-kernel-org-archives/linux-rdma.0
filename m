From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: Re: InfiniBand-ocrdma: Delete unnecessary variable initialisations in
 11 functions
Date: Sat, 16 Jan 2016 09:30:22 +0100
Message-ID: <5699FF9E.3030708@users.sourceforge.net>
References: <5697D865.5010507@users.sourceforge.net>
 <5697DE31.9040309@users.sourceforge.net> <20160115132014.GC30615@leon.nu>
 <56990733.7000506@users.sourceforge.net> <20160115150935.GA32346@leon.nu>
 <56990FAC.6000506@users.sourceforge.net> <20160115155938.GB32346@leon.nu>
 <56991D52.8030808@users.sourceforge.net> <20160115170048.GC32346@leon.nu>
 <56993833.2050809@users.sourceforge.net> <20160116061843.GE32346@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160116061843.GE32346-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, ltp-cunTk1MwBs91InPhgRC9rw@public.gmane.org, users-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Please provide the numbers BEFORE and AFTER your change which can
> support that your so called "fine-tuning" worked.

For which combinations of hardware and software versions would you
like to see corresponding results from detailed system checks
and special benchmarks?


> We are waiting to see it together with Tested-By tag to emphasize
> that your code was tested on real HW and passed minimal sanity checks.

Are any other contributors interested to collaborate for such a task?


> NAK on this patch.

Thanks for your feedback.

Does it mean that you reject (only) the proposed source code adjustments
around the variable "status" in the shown function selection at the moment?

Would you like to clarify the other update steps from this patch series
a bit more?

Regards,
Markus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
