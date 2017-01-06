From: "Anurag Raghavan (RBEI/ETW11)" <Raghavan.Anurag@in.bosch.com>
Subject: ubi_io_read: error -74 (ECC error)
Date: Fri, 6 Jan 2017 10:07:29 +0000
Message-ID: <38f0cfac3dbe4ea89da84c7fbf667833__26578.0724156231$1483697312$gmane$org@SGPMBX1023.APAC.bosch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-snps-arc/>
List-Post: <mailto:linux-snps-arc@lists.infradead.org>
List-Help: <mailto:linux-snps-arc-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=subscribe>
Sender: "linux-snps-arc" <linux-snps-arc-bounces@lists.infradead.org>
Errors-To: linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>, "arnd@arndb.de" <arnd@arndb.de>, "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>, "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>, "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "airlied@linux.ie" <airlied@linux.ie>, "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "linux-am33-list@redhat.com" <linux-am33-list@redhat.com>, "linux-c6x-dev@linux-c6x.org" <linux-c6x-dev@linux-c6x.org>, "linux-rdma@vger.kernel.org" <linux-rdm>
List-Id: linux-rdma@vger.kernel.org

Hi All,

My appdata partition could not be mounted or where the partition was not able to be used. Anyone can help me to find out the root cause of this. What are the possibilities of this ubifs corruption. Any patched are available to fix this issue.

I am using the kernel version-30.3.5
Any kernel patches are available to solve this issue...??

Error logs:

[    1.797141] UBI error: ubi_io_read: error -74 (ECC error) while reading 253952 bytes from PEB 445:8192, read 253952 bytes
[    1.808274] UBIFS error (pid 491): ubifs_scan: corrupt empty space at LEB 489:233760
[    1.816037] UBIFS error (pid 491): ubifs_scanned_corruption: corruption at LEB 489:233760
[    1.828660] UBIFS error (pid 491): ubifs_scan: LEB 489 scanning failed
[    1.835215] UBIFS warning (pid 491): ubifs_ro_mode: switched to read-only mode, error -117
[    1.843502] UBIFS error (pid 491): make_reservation: cannot reserve 58 bytes in jhead 2, error -117
[    1.852569] UBIFS error (pid 491): do_writepage: cannot write page 0 of inode 76584, error -117
dpkg: error: unable to sync new file '/var/lib/dpkg/arch-new': Structure needs cleaning

Best regards

Raghavan Anurag
RBEI/ETW1  

Tel. +91(422)667-4001 | Mobil 9986968950
