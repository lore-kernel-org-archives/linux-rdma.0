From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH 1/2] RDMA/ocrdma: update license from gpl to dual license
Date: Fri, 12 Jun 2015 22:15:04 +0530
Message-ID: <1434127505-17739-2-git-send-email-devesh.sharma@avagotech.com>
References: <1434127505-17739-1-git-send-email-devesh.sharma@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434127505-17739-1-git-send-email-devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch edits the legal statement for ocrdma driver code and
moves it to GPL/Dual-BSD license.

Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |   53 +++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_abi.h   |   53 +++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |   53 +++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h    |   53 +++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |   53 +++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h    |   53 +++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |   53 +++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |   53 +++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c |   53 +++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_stats.h |   53 +++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   53 +++++++++++++++++----------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h |   53 +++++++++++++++++----------
 12 files changed, 408 insertions(+), 228 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index b396344..6a36338 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -1,21 +1,36 @@
-/*******************************************************************
- * This file is part of the Emulex RoCE Device Driver for          *
- * RoCE (RDMA over Converged Ethernet) adapters.                   *
- * Copyright (C) 2008-2012 Emulex. All rights reserved.            *
- * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
- *                                                                 *
- * This program is free software; you can redistribute it and/or   *
- * modify it under the terms of version 2 of the GNU General       *
- * Public License as published by the Free Software Foundation.    *
- * This program is distributed in the hope that it will be useful. *
- * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
- * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
- * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
- * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
- * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
- * more details, a copy of which can be found in the file COPYING  *
- * included with this package.                                     *
+/* This file is part of the Emulex RoCE Device Driver for
+ * RoCE (RDMA over Converged Ethernet) adapters.
+ * Copyright (C) 2012-2015 Emulex. All rights reserved.
+ * EMULEX and SLI are trademarks of Emulex.
+ * www.emulex.com
+ *
+ * This software is available to you under a choice of one of two licenses.
+ * You may choose to be licensed under the terms of the GNU General Public
+ * License (GPL) Version 2, available from the file COPYING in the main
+ * directory of this source tree, or the BSD license below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * - Redistributions of source code must retain the above copyright notice,
+ *   this list of conditions and the following disclaimer.
+ *
+ * - Redistributions in binary form must reproduce the above copyright
+ *   notice, this list of conditions and the following disclaimer in
+ *   the documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
+ * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
+ * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  * Contact Information:
  * linux-drivers-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
@@ -23,7 +38,7 @@
  * Emulex
  * 3333 Susan Street
  * Costa Mesa, CA 92626
- *******************************************************************/
+ */
 
 #ifndef __OCRDMA_H__
 #define __OCRDMA_H__
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_abi.h b/drivers/infiniband/hw/ocrdma/ocrdma_abi.h
index 1554cca..430b135 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_abi.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_abi.h
@@ -1,21 +1,36 @@
-/*******************************************************************
- * This file is part of the Emulex RoCE Device Driver for          *
- * RoCE (RDMA over Converged Ethernet) adapters.                   *
- * Copyright (C) 2008-2012 Emulex. All rights reserved.            *
- * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
- *                                                                 *
- * This program is free software; you can redistribute it and/or   *
- * modify it under the terms of version 2 of the GNU General       *
- * Public License as published by the Free Software Foundation.    *
- * This program is distributed in the hope that it will be useful. *
- * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
- * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
- * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
- * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
- * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
- * more details, a copy of which can be found in the file COPYING  *
- * included with this package.                                     *
+/* This file is part of the Emulex RoCE Device Driver for
+ * RoCE (RDMA over Converged Ethernet) adapters.
+ * Copyright (C) 2012-2015 Emulex. All rights reserved.
+ * EMULEX and SLI are trademarks of Emulex.
+ * www.emulex.com
+ *
+ * This software is available to you under a choice of one of two licenses.
+ * You may choose to be licensed under the terms of the GNU General Public
+ * License (GPL) Version 2, available from the file COPYING in the main
+ * directory of this source tree, or the BSD license below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * - Redistributions of source code must retain the above copyright notice,
+ *   this list of conditions and the following disclaimer.
+ *
+ * - Redistributions in binary form must reproduce the above copyright
+ *   notice, this list of conditions and the following disclaimer in
+ *   the documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
+ * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
+ * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  * Contact Information:
  * linux-drivers-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
@@ -23,7 +38,7 @@
  * Emulex
  * 3333 Susan Street
  * Costa Mesa, CA 92626
- *******************************************************************/
+ */
 
 #ifndef __OCRDMA_ABI_H__
 #define __OCRDMA_ABI_H__
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index 8026e11..b9efef4 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -1,21 +1,36 @@
-/*******************************************************************
- * This file is part of the Emulex RoCE Device Driver for          *
- * RoCE (RDMA over Converged Ethernet) adapters.                   *
- * Copyright (C) 2008-2012 Emulex. All rights reserved.            *
- * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
- *                                                                 *
- * This program is free software; you can redistribute it and/or   *
- * modify it under the terms of version 2 of the GNU General       *
- * Public License as published by the Free Software Foundation.    *
- * This program is distributed in the hope that it will be useful. *
- * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
- * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
- * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
- * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
- * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
- * more details, a copy of which can be found in the file COPYING  *
- * included with this package.                                     *
+/* This file is part of the Emulex RoCE Device Driver for
+ * RoCE (RDMA over Converged Ethernet) adapters.
+ * Copyright (C) 2012-2015 Emulex. All rights reserved.
+ * EMULEX and SLI are trademarks of Emulex.
+ * www.emulex.com
+ *
+ * This software is available to you under a choice of one of two licenses.
+ * You may choose to be licensed under the terms of the GNU General Public
+ * License (GPL) Version 2, available from the file COPYING in the main
+ * directory of this source tree, or the BSD license below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * - Redistributions of source code must retain the above copyright notice,
+ *   this list of conditions and the following disclaimer.
+ *
+ * - Redistributions in binary form must reproduce the above copyright
+ *   notice, this list of conditions and the following disclaimer in
+ *   the documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
+ * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
+ * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  * Contact Information:
  * linux-drivers-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
@@ -23,7 +38,7 @@
  * Emulex
  * 3333 Susan Street
  * Costa Mesa, CA 92626
- *******************************************************************/
+ */
 
 #include <net/neighbour.h>
 #include <net/netevent.h>
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
index 5c4ae3e..d6b678c 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
@@ -1,21 +1,36 @@
-/*******************************************************************
- * This file is part of the Emulex RoCE Device Driver for          *
- * RoCE (RDMA over Converged Ethernet) adapters.                   *
- * Copyright (C) 2008-2012 Emulex. All rights reserved.            *
- * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
- *                                                                 *
- * This program is free software; you can redistribute it and/or   *
- * modify it under the terms of version 2 of the GNU General       *
- * Public License as published by the Free Software Foundation.    *
- * This program is distributed in the hope that it will be useful. *
- * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
- * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
- * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
- * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
- * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
- * more details, a copy of which can be found in the file COPYING  *
- * included with this package.                                     *
+/* This file is part of the Emulex RoCE Device Driver for
+ * RoCE (RDMA over Converged Ethernet) adapters.
+ * Copyright (C) 2012-2015 Emulex. All rights reserved.
+ * EMULEX and SLI are trademarks of Emulex.
+ * www.emulex.com
+ *
+ * This software is available to you under a choice of one of two licenses.
+ * You may choose to be licensed under the terms of the GNU General Public
+ * License (GPL) Version 2, available from the file COPYING in the main
+ * directory of this source tree, or the BSD license below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * - Redistributions of source code must retain the above copyright notice,
+ *   this list of conditions and the following disclaimer.
+ *
+ * - Redistributions in binary form must reproduce the above copyright
+ *   notice, this list of conditions and the following disclaimer in
+ *   the documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
+ * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
+ * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  * Contact Information:
  * linux-drivers-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
@@ -23,7 +38,7 @@
  * Emulex
  * 3333 Susan Street
  * Costa Mesa, CA 92626
- *******************************************************************/
+ */
 
 #ifndef __OCRDMA_AH_H__
 #define __OCRDMA_AH_H__
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 47615ff..aab391a 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1,21 +1,36 @@
-/*******************************************************************
- * This file is part of the Emulex RoCE Device Driver for          *
- * RoCE (RDMA over Converged Ethernet) CNA Adapters.              *
- * Copyright (C) 2008-2012 Emulex. All rights reserved.            *
- * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
- *                                                                 *
- * This program is free software; you can redistribute it and/or   *
- * modify it under the terms of version 2 of the GNU General       *
- * Public License as published by the Free Software Foundation.    *
- * This program is distributed in the hope that it will be useful. *
- * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
- * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
- * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
- * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
- * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
- * more details, a copy of which can be found in the file COPYING  *
- * included with this package.                                     *
+/* This file is part of the Emulex RoCE Device Driver for
+ * RoCE (RDMA over Converged Ethernet) adapters.
+ * Copyright (C) 2012-2015 Emulex. All rights reserved.
+ * EMULEX and SLI are trademarks of Emulex.
+ * www.emulex.com
+ *
+ * This software is available to you under a choice of one of two licenses.
+ * You may choose to be licensed under the terms of the GNU General Public
+ * License (GPL) Version 2, available from the file COPYING in the main
+ * directory of this source tree, or the BSD license below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * - Redistributions of source code must retain the above copyright notice,
+ *   this list of conditions and the following disclaimer.
+ *
+ * - Redistributions in binary form must reproduce the above copyright
+ *   notice, this list of conditions and the following disclaimer in
+ *   the documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
+ * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
+ * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  * Contact Information:
  * linux-drivers-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
@@ -23,7 +38,7 @@
  * Emulex
  * 3333 Susan Street
  * Costa Mesa, CA 92626
- *******************************************************************/
+ */
 
 #include <linux/sched.h>
 #include <linux/interrupt.h>
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.h b/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
index e905972..7ed885c 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.h
@@ -1,21 +1,36 @@
-/*******************************************************************
- * This file is part of the Emulex RoCE Device Driver for          *
- * RoCE (RDMA over Converged Ethernet) CNA Adapters.              *
- * Copyright (C) 2008-2012 Emulex. All rights reserved.            *
- * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
- *                                                                 *
- * This program is free software; you can redistribute it and/or   *
- * modify it under the terms of version 2 of the GNU General       *
- * Public License as published by the Free Software Foundation.    *
- * This program is distributed in the hope that it will be useful. *
- * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
- * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
- * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
- * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
- * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
- * more details, a copy of which can be found in the file COPYING  *
- * included with this package.                                     *
+/* This file is part of the Emulex RoCE Device Driver for
+ * RoCE (RDMA over Converged Ethernet) adapters.
+ * Copyright (C) 2012-2015 Emulex. All rights reserved.
+ * EMULEX and SLI are trademarks of Emulex.
+ * www.emulex.com
+ *
+ * This software is available to you under a choice of one of two licenses.
+ * You may choose to be licensed under the terms of the GNU General Public
+ * License (GPL) Version 2, available from the file COPYING in the main
+ * directory of this source tree, or the BSD license below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * - Redistributions of source code must retain the above copyright notice,
+ *   this list of conditions and the following disclaimer.
+ *
+ * - Redistributions in binary form must reproduce the above copyright
+ *   notice, this list of conditions and the following disclaimer in
+ *   the documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
+ * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
+ * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  * Contact Information:
  * linux-drivers-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
@@ -23,7 +38,7 @@
  * Emulex
  * 3333 Susan Street
  * Costa Mesa, CA 92626
- *******************************************************************/
+ */
 
 #ifndef __OCRDMA_HW_H__
 #define __OCRDMA_HW_H__
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index f552898..cee43c1 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -1,21 +1,36 @@
-/*******************************************************************
- * This file is part of the Emulex RoCE Device Driver for          *
- * RoCE (RDMA over Converged Ethernet) adapters.                   *
- * Copyright (C) 2008-2012 Emulex. All rights reserved.            *
- * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
- *                                                                 *
- * This program is free software; you can redistribute it and/or   *
- * modify it under the terms of version 2 of the GNU General       *
- * Public License as published by the Free Software Foundation.    *
- * This program is distributed in the hope that it will be useful. *
- * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
- * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
- * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
- * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
- * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
- * more details, a copy of which can be found in the file COPYING  *
- * included with this package.                                     *
+/* This file is part of the Emulex RoCE Device Driver for
+ * RoCE (RDMA over Converged Ethernet) adapters.
+ * Copyright (C) 2012-2015 Emulex. All rights reserved.
+ * EMULEX and SLI are trademarks of Emulex.
+ * www.emulex.com
+ *
+ * This software is available to you under a choice of one of two licenses.
+ * You may choose to be licensed under the terms of the GNU General Public
+ * License (GPL) Version 2, available from the file COPYING in the main
+ * directory of this source tree, or the BSD license below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * - Redistributions of source code must retain the above copyright notice,
+ *   this list of conditions and the following disclaimer.
+ *
+ * - Redistributions in binary form must reproduce the above copyright
+ *   notice, this list of conditions and the following disclaimer in
+ *   the documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
+ * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
+ * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  * Contact Information:
  * linux-drivers-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
@@ -23,7 +38,7 @@
  * Emulex
  * 3333 Susan Street
  * Costa Mesa, CA 92626
- *******************************************************************/
+ */
 
 #include <linux/module.h>
 #include <linux/idr.h>
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index 02ad0ae..80006b2 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -1,21 +1,36 @@
-/*******************************************************************
- * This file is part of the Emulex RoCE Device Driver for          *
- * RoCE (RDMA over Converged Ethernet) adapters.                   *
- * Copyright (C) 2008-2012 Emulex. All rights reserved.            *
- * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
- *                                                                 *
- * This program is free software; you can redistribute it and/or   *
- * modify it under the terms of version 2 of the GNU General       *
- * Public License as published by the Free Software Foundation.    *
- * This program is distributed in the hope that it will be useful. *
- * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
- * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
- * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
- * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
- * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
- * more details, a copy of which can be found in the file COPYING  *
- * included with this package.                                     *
+/* This file is part of the Emulex RoCE Device Driver for
+ * RoCE (RDMA over Converged Ethernet) adapters.
+ * Copyright (C) 2012-2015 Emulex. All rights reserved.
+ * EMULEX and SLI are trademarks of Emulex.
+ * www.emulex.com
+ *
+ * This software is available to you under a choice of one of two licenses.
+ * You may choose to be licensed under the terms of the GNU General Public
+ * License (GPL) Version 2, available from the file COPYING in the main
+ * directory of this source tree, or the BSD license below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * - Redistributions of source code must retain the above copyright notice,
+ *   this list of conditions and the following disclaimer.
+ *
+ * - Redistributions in binary form must reproduce the above copyright
+ *   notice, this list of conditions and the following disclaimer in
+ *   the documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
+ * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
+ * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  * Contact Information:
  * linux-drivers-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
@@ -23,7 +38,7 @@
  * Emulex
  * 3333 Susan Street
  * Costa Mesa, CA 92626
- *******************************************************************/
+ */
 
 #ifndef __OCRDMA_SLI_H__
 #define __OCRDMA_SLI_H__
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
index 48d7ef5..69334e2 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
@@ -1,21 +1,36 @@
-/*******************************************************************
- * This file is part of the Emulex RoCE Device Driver for          *
- * RoCE (RDMA over Converged Ethernet) adapters.                   *
- * Copyright (C) 2008-2014 Emulex. All rights reserved.            *
- * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
- *                                                                 *
- * This program is free software; you can redistribute it and/or   *
- * modify it under the terms of version 2 of the GNU General       *
- * Public License as published by the Free Software Foundation.    *
- * This program is distributed in the hope that it will be useful. *
- * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
- * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
- * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
- * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
- * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
- * more details, a copy of which can be found in the file COPYING  *
- * included with this package.                                     *
+/* This file is part of the Emulex RoCE Device Driver for
+ * RoCE (RDMA over Converged Ethernet) adapters.
+ * Copyright (C) 2012-2015 Emulex. All rights reserved.
+ * EMULEX and SLI are trademarks of Emulex.
+ * www.emulex.com
+ *
+ * This software is available to you under a choice of one of two licenses.
+ * You may choose to be licensed under the terms of the GNU General Public
+ * License (GPL) Version 2, available from the file COPYING in the main
+ * directory of this source tree, or the BSD license below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * - Redistributions of source code must retain the above copyright notice,
+ *   this list of conditions and the following disclaimer.
+ *
+ * - Redistributions in binary form must reproduce the above copyright
+ *   notice, this list of conditions and the following disclaimer in
+ *   the documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
+ * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
+ * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  * Contact Information:
  * linux-drivers-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
@@ -23,7 +38,7 @@
  * Emulex
  * 3333 Susan Street
  * Costa Mesa, CA 92626
- *******************************************************************/
+ */
 
 #include <rdma/ib_addr.h>
 #include <rdma/ib_pma.h>
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.h b/drivers/infiniband/hw/ocrdma/ocrdma_stats.h
index 091edd6..c9e58d0 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.h
@@ -1,21 +1,36 @@
-/*******************************************************************
- * This file is part of the Emulex RoCE Device Driver for          *
- * RoCE (RDMA over Converged Ethernet) adapters.                   *
- * Copyright (C) 2008-2014 Emulex. All rights reserved.            *
- * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
- *                                                                 *
- * This program is free software; you can redistribute it and/or   *
- * modify it under the terms of version 2 of the GNU General       *
- * Public License as published by the Free Software Foundation.    *
- * This program is distributed in the hope that it will be useful. *
- * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
- * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
- * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
- * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
- * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
- * more details, a copy of which can be found in the file COPYING  *
- * included with this package.                                     *
+/* This file is part of the Emulex RoCE Device Driver for
+ * RoCE (RDMA over Converged Ethernet) adapters.
+ * Copyright (C) 2012-2015 Emulex. All rights reserved.
+ * EMULEX and SLI are trademarks of Emulex.
+ * www.emulex.com
+ *
+ * This software is available to you under a choice of one of two licenses.
+ * You may choose to be licensed under the terms of the GNU General Public
+ * License (GPL) Version 2, available from the file COPYING in the main
+ * directory of this source tree, or the BSD license below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * - Redistributions of source code must retain the above copyright notice,
+ *   this list of conditions and the following disclaimer.
+ *
+ * - Redistributions in binary form must reproduce the above copyright
+ *   notice, this list of conditions and the following disclaimer in
+ *   the documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
+ * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
+ * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  * Contact Information:
  * linux-drivers-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
@@ -23,7 +38,7 @@
  * Emulex
  * 3333 Susan Street
  * Costa Mesa, CA 92626
- *******************************************************************/
+ */
 
 #ifndef __OCRDMA_STATS_H__
 #define __OCRDMA_STATS_H__
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index fcb8674..f91eabd 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1,21 +1,36 @@
-/*******************************************************************
- * This file is part of the Emulex RoCE Device Driver for          *
- * RoCE (RDMA over Converged Ethernet) adapters.                   *
- * Copyright (C) 2008-2012 Emulex. All rights reserved.            *
- * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
- *                                                                 *
- * This program is free software; you can redistribute it and/or   *
- * modify it under the terms of version 2 of the GNU General       *
- * Public License as published by the Free Software Foundation.    *
- * This program is distributed in the hope that it will be useful. *
- * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
- * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
- * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
- * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
- * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
- * more details, a copy of which can be found in the file COPYING  *
- * included with this package.                                     *
+/* This file is part of the Emulex RoCE Device Driver for
+ * RoCE (RDMA over Converged Ethernet) adapters.
+ * Copyright (C) 2012-2015 Emulex. All rights reserved.
+ * EMULEX and SLI are trademarks of Emulex.
+ * www.emulex.com
+ *
+ * This software is available to you under a choice of one of two licenses.
+ * You may choose to be licensed under the terms of the GNU General Public
+ * License (GPL) Version 2, available from the file COPYING in the main
+ * directory of this source tree, or the BSD license below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * - Redistributions of source code must retain the above copyright notice,
+ *   this list of conditions and the following disclaimer.
+ *
+ * - Redistributions in binary form must reproduce the above copyright
+ *   notice, this list of conditions and the following disclaimer in
+ *   the documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
+ * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
+ * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  * Contact Information:
  * linux-drivers-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
@@ -23,7 +38,7 @@
  * Emulex
  * 3333 Susan Street
  * Costa Mesa, CA 92626
- *******************************************************************/
+ */
 
 #include <linux/dma-mapping.h>
 #include <rdma/ib_verbs.h>
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
index 3cdc81e..74ad252 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
@@ -1,21 +1,36 @@
-/*******************************************************************
- * This file is part of the Emulex RoCE Device Driver for          *
- * RoCE (RDMA over Converged Ethernet) adapters.                   *
- * Copyright (C) 2008-2012 Emulex. All rights reserved.            *
- * EMULEX and SLI are trademarks of Emulex.                        *
- * www.emulex.com                                                  *
- *                                                                 *
- * This program is free software; you can redistribute it and/or   *
- * modify it under the terms of version 2 of the GNU General       *
- * Public License as published by the Free Software Foundation.    *
- * This program is distributed in the hope that it will be useful. *
- * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
- * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
- * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
- * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
- * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
- * more details, a copy of which can be found in the file COPYING  *
- * included with this package.                                     *
+/* This file is part of the Emulex RoCE Device Driver for
+ * RoCE (RDMA over Converged Ethernet) adapters.
+ * Copyright (C) 2012-2015 Emulex. All rights reserved.
+ * EMULEX and SLI are trademarks of Emulex.
+ * www.emulex.com
+ *
+ * This software is available to you under a choice of one of two licenses.
+ * You may choose to be licensed under the terms of the GNU General Public
+ * License (GPL) Version 2, available from the file COPYING in the main
+ * directory of this source tree, or the BSD license below:
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * - Redistributions of source code must retain the above copyright notice,
+ *   this list of conditions and the following disclaimer.
+ *
+ * - Redistributions in binary form must reproduce the above copyright
+ *   notice, this list of conditions and the following disclaimer in
+ *   the documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
+ * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
+ * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  * Contact Information:
  * linux-drivers-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
@@ -23,7 +38,7 @@
  * Emulex
  * 3333 Susan Street
  * Costa Mesa, CA 92626
- *******************************************************************/
+ */
 
 #ifndef __OCRDMA_VERBS_H__
 #define __OCRDMA_VERBS_H__
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
