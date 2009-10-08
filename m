From: "Sean Hefty" <sean.hefty@intel.com>
Subject: RE: [PATCH] opensm - add OSM_CDECL to qsort compare
	function	definitions
Date: Thu, 8 Oct 2009 10:10:34 -0700
Message-ID: <7E11A1A23B5A46DB8BB84556E67BF487@amr.corp.intel.com>
References: <6678A2C4663F40F3AC7B364C6ACFCC9F@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <6678A2C4663F40F3AC7B364C6ACFCC9F@amr.corp.intel.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "Smith, Stan" <stan.smith@intel.com>, 'Sasha Khapyorsky' <sashak@voltaire.com>
Cc: ofw@lists.openfabrics.org, 'linux-rdma' <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

>X86 linkage requires __cdecl attribute on qsort() compare function definition;
>matches Windows qsort() prototype.
>Add existing OSM_CDECL to qsort() compare function defintions.
>OSM_CDECL defined blank for Linux.

ibping also requires the use __cdecl.  So far, I've been maintaining that patch
separately and applying it before updating the winof code base.  If multiple
users of __cdecl are required, maybe we can find a common place for the
definition.

- Sean
