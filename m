From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs v2 00/11] make read_config() more robust
Date: Thu,  8 Aug 2013 21:40:43 +0200
Message-ID: <cover.1375952089.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Please find patches to protect libibverbs from using invalid,
unsecure configuration files.

Thoses configurations files are usually located in
/etc/libibverbs.d/ and contains the name of a shared library
to dlopen().

Only legitimate shared libraries should be loaded by libibverbs,
so it must be careful on the configuration files used.

Changes from v1:

- rewrote the way files are accessed to use openat()
- made the ownership/permissions checking allow access to user owned files.
- reject symlinks

Yann Droneaud (11):
  read_config(): ignore files beginning with '.'
  read_config(): ignore directory entry with backup suffix (~)
  read_config(): open configuration directory with open()
  read_config(): move file type check in read_config_file()
  read_config_file(): use the directory file descriptor to open
    configuration file
  read_config_file(): check opened file
  read_config(): check opened directory
  read_config(): refuse to open IBV_CONFIG_DIR if it's not a directory
  Check owner/permissions of config directory/files
  read_config(): reject symlinks
  read_config_file(): refuse to open configuration file if it's symlink

 configure.ac |  12 ++++++
 src/init.c   | 135 ++++++++++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 123 insertions(+), 24 deletions(-)

-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
