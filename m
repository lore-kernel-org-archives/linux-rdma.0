From: "Sean Hefty" <sean.hefty@intel.com>
Subject: RE: [PATCH] opensm - standardize on a single Windows #define
Date: Thu, 8 Oct 2009 10:06:22 -0700
Message-ID: <21B1AC3C6F82416A8764CF0B6FD9C27B@amr.corp.intel.com>
References: <C014357BC392401989734C286EDC5AE1@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <C014357BC392401989734C286EDC5AE1@amr.corp.intel.com>
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

>Code cleanup, standardize on a single Windows #define '__WIN__'; WIN32 -->
>__WIN__.
>Flip usage of ifndef WIN32 --> ifdef __GNUC__

GNUC indicates a specific compiler, not a platform, which is what the check is
for.
