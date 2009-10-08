From: "Sean Hefty" <sean.hefty@intel.com>
Subject: RE: [PATCH] opensm - add OSM_CDECL to qsort compare
	function	definitions
Date: Thu, 8 Oct 2009 11:09:16 -0700
Message-ID: <6B5BF67BFC91485DB2A88EBE2F681A81@amr.corp.intel.com>
References: <6678A2C4663F40F3AC7B364C6ACFCC9F@amr.corp.intel.com>
	<7E11A1A23B5A46DB8BB84556E67BF487@amr.corp.intel.com>
	<20091008175957.GZ5191@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <20091008175957.GZ5191@obsidianresearch.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: 'Jason Gunthorpe' <jgunthorpe@obsidianresearch.com>
Cc: ofw@lists.openfabrics.org, 'Sasha Khapyorsky' <sashak@voltaire.com>, 'linux-rdma' <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

>> ibping also requires the use __cdecl.  So far, I've been maintaining
>> that patch separately and applying it before updating the winof code
>> base.  If multiple users of __cdecl are required, maybe we can find
>> a common place for the definition.
>
>I don't get it - how can an ISO C conforming compiler require a
>non-standard declaration on the function argument to the ISO C
>function qsort?

The windows compiler uses stdcall as the default function type.  With ibping,
the signal() call, and I'm guessing this is the same with qsort(), requires that
the function passed in as an arg be cdecl.  So, in the case of ibping:

void report(int sig)

needs to be written as

void __cdecl report(int sig)

to compile for x86.  I have no idea why only the x86 build that complains.
Since this is the only difference between the linux and windows code, I've just
maintained the patch to add it separately.

- Sean
