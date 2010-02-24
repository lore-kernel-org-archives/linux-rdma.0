From: "Davis, Arlin R" <arlin.r.davis@intel.com>
Subject: [ANNOUNCE] dapl-2.0.27 and compat-dapl-1.2.16 release
Date: Tue, 23 Feb 2010 17:23:40 -0800
Message-ID: <E3280858FA94444CA49D2BA02341C983B59811C2@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, ofw_list <ofw@lists.openfabrics.org>
Cc: Vladimir Sokolovsky <vlad@mellanox.co.il>, Jimmy Hill <jimmy.hill@us.ibm.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

 
New release for uDAPL v2.0 (2.0.23) and v1.2 (1.2.16) available at:

http://www.openfabrics.org/downloads/dapl

Latest Packages (see ChangeLog for details):

md5sum: e0995e0f9bc416a8478720953fa1cc63 compat-dapl-1.2.16.tar.gz 
md5sum: 999734fc1f2e27b5fc98dd6fd486daf9 dapl-2.0.27.tar.gz 

Vlad, please pull into OFED 1.5.1:

For 1.2 and 2.0 support on same system, including development, install RPM packages as follow: 

dapl-2.0.27-1 
dapl-utils-2.0.27-1 
dapl-devel-2.0.27-1 
dapl-debuginfo-2.0.27-1 
compat-dapl-1.2.16-1 
compat-dapl-devel-1.2.16-1 

Summary of changes: 

Release 2.0.27 fixes: 
- windows: add scm makefile 
- Windows does not require rdma_cma_abi.h, move the include from common code 
- Windows patch to fix IB_INVALID_HANDLE name collision 
- scm: dat_ep_connect fails on 32bit servers 
- undefined symbol: dapls_print_cm_list 
- Cleanup CM object lock before freeing CM object memory 
- destroy verbs completion channels created via ia_open or ep_create. 
- Update Copyright file and include the 3 license files in distribution 
- When copying private_data out of rdma_cm events, use the 
- dapl/cma: fix referencing freed address 
- dapl: move close device after async thread is done 

Release 1.2.16 fixes: 
- Update Copyright file and include the 3 license files in distribution 
- cma: max sge incorrectly decremented during ibv_device_query 

Thanks,

-arlin
