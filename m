From: "Sean Hefty" <sean.hefty@intel.com>
Subject: RE: RE: [PATCH 1/2] contain pthreads defs with
	ifdef	HAVE_LIBPTHREAD
Date: Wed, 4 Nov 2009 13:06:33 -0800
Message-ID: <E43D433FD5894356829B833CCEC02E39@amr.corp.intel.com>
References: <F9EFFFF3BD1D442AB6AA993FD6F0B5D8@amr.corp.intel.com>
	<74DB7ADB8B154DE69B8F65456193D483@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <74DB7ADB8B154DE69B8F65456193D483@amr.corp.intel.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "Hefty, Sean" <sean.hefty@intel.com>, "Smith, Stan" <stan.smith@intel.com>, 'Sasha Khapyorsky' <sashak@voltaire.com>
Cc: linux-rdma@vger.kernel.org, ofw@lists.openfabrics.org
List-Id: linux-rdma@vger.kernel.org

>Alternately, #define cl_mutex_t pthread_mutex_t and avoid the #ifdef's

switch that define around...
