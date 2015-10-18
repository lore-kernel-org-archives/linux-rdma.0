From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: IB/ipath: use TASK_COMM_LEN in ipath_portdata
Date: Sat, 17 Oct 2015 22:05:09 -0700
Message-ID: <20151018050509.GA2703@kroah.com>
References: <d18008076bca0bf3f06ebd8c76bc71c0e2019517.1444394307.git.geliangtang@163.com>
 <85f5a431a363d505975b2aee477673ef12ea4f63.1444395550.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <85f5a431a363d505975b2aee477673ef12ea4f63.1444395550.git.geliangtang@163.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Geliang Tang <geliangtang@163.com>
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 08, 2015 at 10:04:27PM -0700, Geliang Tang wrote:
> Use comm[TASK_COMM_LEN] instead of comm[16]. Add linux/sched.h
> header in ipath_kernel.h, and remove linux/sched.h header from
> ipath_*.c which have included ipath_kernel.h.

That's a lot of different things to be doing all in one patch.  Please
break this up into different patches and resend.

Also please add the "staging:" prefix to your subject lines, like I
changed it to here, that makes it easier for me to notice and handle
your patches properly.

thanks,

greg k-h
