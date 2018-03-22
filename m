From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v4 4/6] infiniband: cxgb4: Eliminate duplicate barriers
 on weakly-ordered archs
Date: Thu, 22 Mar 2018 12:48:33 -0600
Message-ID: <20180322184833.GB9469@ziepe.ca>
References: <1521514068-8856-5-git-send-email-okaya@codeaurora.org>
 <201803221430.P43GJl9U%fengguang.wu@intel.com>
 <3664b253c730dbf83f4528acaedb3a88@codeaurora.org>
 <3e9c006e4541acbce11743dbda553e84@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3e9c006e4541acbce11743dbda553e84@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: okaya@codeaurora.org
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org, linux-rdma@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 22, 2018 at 08:48:35AM -0400, okaya@codeaurora.org wrote:
> On 2018-03-22 08:24, okaya@codeaurora.org wrote:
> >On 2018-03-22 02:44, kbuild test robot wrote:
> >>Hi Sinan,
> >>
> >>Thank you for the patch! Yet something to improve:
> >>
> >>[auto build test ERROR on linus/master]
> >>[also build test ERROR on v4.16-rc6 next-20180321]
> >>[if your patch is applied to the wrong git tree, please drop us a note
> >>to help improve the system]
> >>
> >>url:
> >>https://github.com/0day-ci/linux/commits/Sinan-Kaya/ib-Eliminate-duplicate-barriers-on-weakly-ordered-archs/20180321-091659
> >>config: xtensa-allyesconfig (attached as .config)
> >>compiler: xtensa-linux-gcc (GCC) 7.2.0
> >>reproduce:
> >>        wget
> >>https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross
> >>-O ~/bin/make.cross
> >>        chmod +x ~/bin/make.cross
> >>        # save the attached .config to linux build tree
> >>        make.cross ARCH=xtensa
> >>
> >
> >Jason,
> >
> >Can you remove the writeq change if it is too late for me to fix?
> >
> >This is an infrastructural issue on xtensa arch.
> >
> >Probably, it won't get fixed today.
> 
> AFAIS, even writeq won't compile on this arch. I started questioning this
> build test.

I have the same confusion. Did you figure out an explanation?

Jason
