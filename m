From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: SRPt oops with 4.5-rc3-ish
Date: Sun, 28 Feb 2016 08:14:01 -0800
Message-ID: <56D31CC9.7000609@sandisk.com>
References: <56C0A6C3.3010903@redhat.com>
 <1456630639.19657.47.camel@haakon3.risingtidesystems.com>
 <1456647963.19657.135.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456647963.19657.135.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Doug Ledford <dledford@redhat.com>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 02/28/16 00:26, Nicholas A. Bellinger wrote:
> Please confirm when you started triggering this regression during target
> service restart.

Hi Nic,

Are you aware that Doug was not the first person to report this crash? I 
had already reported this crash myself seven weeks ago. Together with 
the report of this crash I had also sent a root cause analysis to you 
and a fix. In the patch description I explained clearly that this crash 
is caused by a bug in the LIO core and should be fixed in the LIO core. 
See also Bart Van Assche, [PATCH 07/21] target: Fix a use-after-free in 
core_tpg_del_initiator_node_acl(), target-devel mailing list, January 5, 
2016 
(http://thread.gmane.org/gmane.linux.scsi.target.devel/10905/focus=10891).

Bart.
