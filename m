From: Leon Romanovsky <leon@leon.nu>
Subject: Re: InfiniBand-ocrdma: Delete unnecessary variable initialisations
 in 11 functions
Date: Fri, 15 Jan 2016 19:41:50 +0200
Message-ID: <20160115174150.GD32346@leon.nu>
References: <5697D865.5010507@users.sourceforge.net>
 <5697DE31.9040309@users.sourceforge.net>
 <20160115132014.GC30615@leon.nu>
 <56990733.7000506@users.sourceforge.net>
 <20160115150935.GA32346@leon.nu>
 <56990FAC.6000506@users.sourceforge.net>
 <20160115155938.GB32346@leon.nu>
 <56991D52.8030808@users.sourceforge.net>
 <20160115170048.GC32346@leon.nu>
 <56992A2A.4020104@sandisk.com>
Reply-To: leon@leon.nu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56992A2A.4020104@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>, linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mitesh Ahuja <mitesh.ahuja@avagotech.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 15, 2016 at 09:19:38AM -0800, Bart Van Assche wrote:
> On 01/15/2016 09:00 AM, Leon Romanovsky wrote:
> >On Fri, Jan 15, 2016 at 05:24:50PM +0100, SF Markus Elfring wrote:
> >
> >Since, you didn't answer to my original question, I will repeat it again.
> >[Q.] What did you try to achieve by this patch?
> 
> Hello Leon,
> 
> Have you noticed Dan's reply: "Doing bogus initializations turns off GCC's
> checking for uninitialized variables so it's a bad habit."

Yes and his second part of that message too, that uninitialized
checks in GCC work as not as expected [1, 2].

Stackoverflow site has a lot examples of these types of bugs [3].
These examples together with Dan's suggestion requires from all
reviewers to be extra cautions when removing variable initialization.

[1] https://gcc.gnu.org/wiki/Better_Uninitialized_Warnings
[2] https://gcc.gnu.org/bugzilla/buglist.cgi?quicksearch=may%20be%20uninitialized
[3] http://stackoverflow.com/questions/27063678/compiler-not-detecting-obviously-uninitialized-variable

> 
> Thanks,
> 
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
