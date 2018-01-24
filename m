From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: SQ overflow seen running isert traffic with high block sizes
Date: Tue, 23 Jan 2018 23:55:34 -0800
Message-ID: <1516780534.24576.335.camel@haakon3.daterainc.com>
References: <BN3PR07MB25784033E7FCD062FA0A7855F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
         <210f538f-8c98-f480-64fc-f2124ed6d01b@grimberg.me>
         <BN3PR07MB25786338EADC77A369A6D493F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
         <1499970579.7987.8.camel@haakon3.daterainc.com>
         <BN3PR07MB2578E6561CC669922A322245F8A00@BN3PR07MB2578.namprd07.prod.outlook.com>
         <20171006224025.GA23364@ssaleem-MOBL4.amr.corp.intel.com>
         <1515992195.24576.156.camel@haakon3.daterainc.com>
         <CY1PR0701MB2012E53C69D1CE3E16BA320B88EB0@CY1PR0701MB2012.namprd07.prod.outlook.com>
         <20180115152236.GA15484@ssaleem-MOBL4.amr.corp.intel.com>
         ,<1516269522.24576.274.camel@haakon3.daterainc.com>
         <CY1PR0701MB2012C8513D9048FC1CC7011088EF0@CY1PR0701MB2012.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CY1PR0701MB2012C8513D9048FC1CC7011088EF0@CY1PR0701MB2012.namprd07.prod.outlook.com>
Sender: target-devel-owner@vger.kernel.org
To: "Kalderon, Michal" <Michal.Kalderon@cavium.com>
Cc: Shiraz Saleem <shiraz.saleem@intel.com>, "Amrani, Ram" <Ram.Amrani@cavium.com>, Sagi Grimberg <sagi@grimberg.me>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Elior, Ariel" <Ariel.Elior@cavium.com>, target-devel <target-devel@vger.kernel.org>, Potnuri Bharat Teja <bharat@chelsio.com>, "Radzi, Amit" <Amit.Radzi@cavium.com>, "Galon, Yoav" <Yoav.Galon@cavium.com>
List-Id: linux-rdma@vger.kernel.org

Hi Michal & Co,

On Fri, 2018-01-19 at 19:33 +0000, Kalderon, Michal wrote:
> ________________________________________
> From: Nicholas A. Bellinger <nab@linux-iscsi.org>
> Sent: Thursday, January 18, 2018 11:58 AM
> 
> > Hi Shiraz, Michal & Co,
> Hi Nicholas, 
> 
> > Thanks for the feedback.  Comments below.
> 
> > A couple of thoughts.
> 
> > First, would it be helpful to limit maximum payload size per I/O for
> > consumers based on number of iser-target sq hw sges..?
> 
> I don't think you need to limit the maximum payload, but instead 
> initialize the max_wr to be based on the number of supported SGEs
> Instead of what is there today:
> #define ISERT_QP_MAX_REQ_DTOS   (ISCSI_DEF_XMIT_CMDS_MAX +    \
>                                 ISERT_MAX_TX_MISC_PDUS  + \
>                                 ISERT_MAX_RX_MISC_PDUS)
> Add the maximum number of WQEs per command, 
> The calculation of number of WQEs per command needs to be something like
> "MAX_TRANSFER_SIZE/(numSges*PAGE_SIZE)".
> 

Makes sense, MAX_TRANSFER_SIZE would be defined globally by iser-target,
right..?

Btw, I'm not sure how this effects usage of ISER_MAX_TX_CQ_LEN +
ISER_MAX_CQ_LEN, which currently depend on ISERT_QP_MAX_REQ_DTOS..

Sagi, what are your thoughts wrt changing attr.cap.max_send_wr at
runtime vs. exposing a smaller max_data_sg_nents=32 for ib_devices with
limited attr.cap.max_send_sge..?

> For some devices like ours, breaking the IO into multiple WRs according to supported
> number of SGEs doesn't necessarily means performance penalty.
> 

AFAICT ading max_data_sg_nents for iser-target is safe enough
work-around to include for stable, assuming we agree on what the
max_send_sg cut-off is for setting max_data_sg_nents=32 usage from a
larger default.  I don't have a string preference either way, as long as
it can be picked up for 4.x stable.

Sagi, WDYT..?
