From: Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: SQ overflow seen running isert traffic with high block sizes
Date: Fri, 26 Jan 2018 12:52:54 -0600
Message-ID: <20180126185254.GA13768@ssaleem-MOBL4.amr.corp.intel.com>
References: <BN3PR07MB25786338EADC77A369A6D493F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <1499970579.7987.8.camel@haakon3.daterainc.com>
 <BN3PR07MB2578E6561CC669922A322245F8A00@BN3PR07MB2578.namprd07.prod.outlook.com>
 <20171006224025.GA23364@ssaleem-MOBL4.amr.corp.intel.com>
 <1515992195.24576.156.camel@haakon3.daterainc.com>
 <CY1PR0701MB2012E53C69D1CE3E16BA320B88EB0@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20180115152236.GA15484@ssaleem-MOBL4.amr.corp.intel.com>
 <1516269522.24576.274.camel@haakon3.daterainc.com>
 <9DD61F30A802C4429A01CA4200E302A789EB485A@fmsmsx116.amr.corp.intel.com>
 <1516780918.24576.341.camel@haakon3.daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516780918.24576.341.camel@haakon3.daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Kalderon, Michal" <Michal.Kalderon@cavium.com>, "Amrani, Ram" <Ram.Amrani@cavium.com>, Sagi Grimberg <sagi@grimberg.me>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Elior, Ariel" <Ariel.Elior@cavium.com>, target-devel <target-devel@vger.kernel.org>, Potnuri Bharat Teja <bharat@chelsio.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 24, 2018 at 01:01:58AM -0700, Nicholas A. Bellinger wrote:
> Hi Shiraz & Co,
> 
> Thanks for the feedback.
> 
> On Mon, 2018-01-22 at 17:49 +0000, Saleem, Shiraz wrote:
> > > Subject: Re: SQ overflow seen running isert traffic with high block sizes
> > > 
> > > 
> > > First, would it be helpful to limit maximum payload size per I/O for consumers
> > > based on number of iser-target sq hw sges..?
> > > 
> > Assuming data is not able to be fast registered as if virtually contiguous;
> > artificially limiting the data size might not be the best solution.
> > 
> > But max SGEs does need to be exposed higher. Somewhere in the stack,
> > there might need to be multiple WRs submitted or data copied.
> > 
> 
> Sagi..?
> 

> 
> For reference, what is i40iw's max_send_sg reporting..?

3

> 
> Is max_data_sg_nents=32 + 4k pages = 128K the largest MAX TRANSFER
> LENGTH to avoid consistent SQ overflow as-is with i40iw..?

For the configuration I am testing, max_data_sg_nents=32 & 64 worked,
and the SQ overflow issue reproduced at 128.
