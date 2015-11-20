From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH 02/18] staging/rdma/hfi1: Decode CNP opcode
Date: Fri, 20 Nov 2015 14:37:48 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC259BD693@fmsmsx120.amr.corp.intel.com>
References: <1447472236-622-1-git-send-email-jubin.john@intel.com>
 <1447472236-622-2-git-send-email-jubin.john@intel.com>
 <20151120010906.GB11695@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20151120010906.GB11695@kroah.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

> > Add CNP opcode decode
> 
> Why?

Prior to this patch the trace appeared like:

<idle>-0     [001] d.h. 94062.578932: input_ibhdr: [0000:05:00.0] vl 0 lver 0
sl 0 lnh 2,LRH_BTH dlid 0003 len 6 slid 0001 op 0x80,0x80 se 0 m 0 pad 0 tver 0
pkey 0x8001 f 0 b 0 qpn 0x001234 a 0 psn 0x00000000

Note the "op 0x80,0x80".

With this patch:

          <idle>-0     [000] d.h. 233975.912059: input_ibhdr: [0000:05:00.0] vl
0 lver 0 sl 0 lnh 2,LRH_BTH dlid 0015 len 6 slid 0014 op 0x80,CNP se 0 m 0 pad
0 tver 0 pkey 0x8001 f 0 b 0 qpn 0x001234 a 0 psn 0x00000000

Note the "op 0x80,CNP"

Mike
