From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 2/2] staging: IB/ipath: remove sched.h header
Date: Sat, 24 Oct 2015 19:05:32 -0700
Message-ID: <20151025020532.GA22888@kroah.com>
References: <a1a9b6edcb6bbdc079476c99a4add4b21b4414ba.1445175749.git.geliangtang@163.com>
 <7653f784da256d3424c84d2c743d660219d66499.1445175749.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <7653f784da256d3424c84d2c743d660219d66499.1445175749.git.geliangtang@163.com>
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

On Sun, Oct 18, 2015 at 09:57:09PM +0800, Geliang Tang wrote:
> sched.h header in ipath_*.c is now unnecessary, since I have added
> sched.h in ipath_kernel.h. So remove it.

Overall, it's best to split this type of thing out, don't "hide" .h
includes in another .h file, so I'm not going to take this patch, sorry.

thanks,

greg k-h
