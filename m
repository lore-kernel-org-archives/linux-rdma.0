From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 3/9] rdma: Add filtering infrastructure
Date: Tue,  2 Jan 2018 11:37:19 +0200
Message-ID: <20180102093725.6172-4-leon@kernel.org>
References: <20180102093725.6172-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180102093725.6172-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, David Ahern <dsahern@gmail.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

This patch adds general infrastructure to RDMAtool to handle various
filtering options needed for the downstream resource tracking patches.

The infrastructure is generic and stores filters in list of key<->value
entries. There are three types of filters:

1. Numeric - the values are intended to be digits combined with '-' to
mark range and ',' to mark multiple entries, e.g. pid 1-100,234,400-401
is perfectly legit filter to limit process ids.

2. String - the values are consist from strings and "," as a
denominator. Currently only "display" option is opened for the users and
it will be used to hide/unhide table columns in resource tracking
patches.

3. Link - special case to allow '/' in string to provide link name, e.g.
link mlx4_1/2.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/rdma.c  |   1 +
 rdma/rdma.h  |  15 +++++
 rdma/utils.c | 212 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 228 insertions(+)

diff --git a/rdma/rdma.c b/rdma/rdma.c
index 0e8fd688..a21ba440 100644
--- a/rdma/rdma.c
+++ b/rdma/rdma.c
@@ -47,6 +47,7 @@ static int rd_init(struct rd *rd, int argc, char **argv, char *filename)
 	rd->argc = argc;
 	rd->argv = argv;
 	INIT_LIST_HEAD(&rd->dev_map_list);
+	INIT_LIST_HEAD(&rd->filter_list);
 
 	if (rd->json_output) {
 		rd->jw = jsonw_new(stdout);
diff --git a/rdma/rdma.h b/rdma/rdma.h
index 1b66ae04..cd415670 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -29,6 +29,12 @@
 #define RDMA_BITMAP_ENUM(name, bit_no) RDMA_BITMAP_##name = BIT(bit_no),
 #define RDMA_BITMAP_NAMES(name, bit_no) [bit_no] = #name,
 
+struct filter_entry {
+	struct list_head list;
+	char *key;
+	char *value;
+};
+
 struct dev_map {
 	struct list_head list;
 	char *dev_name;
@@ -50,6 +56,7 @@ struct rd {
 	json_writer_t *jw;
 	bool json_output;
 	bool pretty_output;
+	struct list_head filter_list;
 };
 
 struct rd_cmd {
@@ -81,6 +88,14 @@ int rd_argc(struct rd *rd);
  */
 struct dev_map *dev_map_lookup(struct rd *rd, bool allow_port_index);
 
+/*
+ * Filter manipulation
+ */
+int rd_build_filter(struct rd *rd, const char * const valid_filters[]);
+bool rd_check_is_filtered(struct rd *rd, const char *key,
+			  uint32_t val, bool ignore_val);
+bool rd_check_is_string_filtered(struct rd *rd, const char *key, char *val);
+bool rd_check_is_key_exist(struct rd *rd, const char *key);
 /*
  * Netlink
  */
diff --git a/rdma/utils.c b/rdma/utils.c
index 9184f455..dc9f4f01 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -114,6 +114,217 @@ static void dev_map_cleanup(struct rd *rd)
 	}
 }
 
+static int add_filter(struct rd *rd, char *key, char *value,
+		      const char * const valid_filters[])
+{
+	char cset[] = "1234567890,-";
+	struct filter_entry *fe;
+	bool key_found = false;
+	int idx = 0;
+	int ret;
+
+	fe = calloc(1, sizeof(*fe));
+	if (!fe)
+		return -ENOMEM;
+
+	while (valid_filters[idx]) {
+		if (!strcmpx(key, valid_filters[idx])) {
+			key_found = true;
+			break;
+		}
+		idx++;
+	}
+	if (!key_found) {
+		pr_err("Unsupported filter option: %s\n", key);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/*
+	 * Check the filter validity, not optimal, but works
+	 *
+	 * Actually, there are three types of filters
+	 *  numeric - for example PID or QPN
+	 *  string  - for example states, currently only "display"
+	 *            is from this type
+	 *  link    - user requested to filter on specific link
+	 *            e.g. mlx5_1/1, mlx5_1/-, mlx5_1 ...
+	 */
+	if (strcmpx(key, "link") && strcmpx(key, "display") &&
+	    strspn(value, cset) != strlen(value)) {
+		pr_err("%s filter accepts \"%s\" characters only\n", key, cset);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	fe->key = strdup(key);
+	fe->value = strdup(value);
+
+	list_add_tail(&fe->list, &rd->filter_list);
+	return 0;
+
+err:
+	free(fe);
+	return ret;
+}
+
+int rd_build_filter(struct rd *rd, const char * const valid_filters[])
+{
+	int ret = 0;
+	int idx = 0;
+
+	if (!valid_filters || !rd_argc(rd))
+		goto out;
+
+	if (rd_argc(rd) == 1) {
+		pr_err("No filter data was supplied to filter option %s\n", rd_argv(rd));
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (rd_argc(rd) % 2) {
+		pr_err("There is filter option without data\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	while (idx != rd_argc(rd)) {
+		/*
+		 * We can do micro-optimization and skip "dev"
+		 * and "link" filters, but it is not worth of it.
+		 */
+		ret = add_filter(rd, *(rd->argv + idx),
+				 *(rd->argv + idx + 1), valid_filters);
+		if (ret)
+			goto out;
+		idx += 2;
+	}
+
+out:
+	return ret;
+}
+
+bool rd_check_is_key_exist(struct rd *rd, const char *key)
+{
+	struct filter_entry *fe;
+
+	list_for_each_entry(fe, &rd->filter_list, list) {
+		if (!strcmpx(fe->key, key))
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * Check if string entry is filtered:
+ *  * key doesn't exist -> user didn't request -> not filtered
+ */
+bool rd_check_is_string_filtered(struct rd *rd, const char *key, char *val)
+{
+	bool key_is_filtered = false;
+	struct filter_entry *fe;
+	char *p = NULL;
+	char *str;
+
+	list_for_each_entry(fe, &rd->filter_list, list) {
+		if (!strcmpx(fe->key, key)) {
+			/* We found the key */
+			p = strdup(fe->value);
+
+			/*
+			 * Need to check if value in range
+			 * It can come in the following formats
+			 * and their permutations:
+			 * str
+			 * str1,str2
+			 */
+			str = strtok(p, ",");
+			while (str) {
+				if (!strcmpx(str, val)) {
+					key_is_filtered = true;
+					goto out;
+				}
+				str = strtok(NULL, ",");
+			}
+			goto out;
+		}
+	}
+
+out:
+	free(p);
+	return key_is_filtered;
+}
+
+/*
+ * Check if key is filtered:
+ * key doesn't exist -> user didn't request -> not filtered
+ */
+bool rd_check_is_filtered(struct rd *rd, const char *key,
+			  uint32_t val, bool ignore_val)
+{
+	bool key_is_filtered = false;
+	struct filter_entry *fe;
+
+	list_for_each_entry(fe, &rd->filter_list, list) {
+		uint32_t left_val = 0, fe_value = 0;
+		bool range_check = false;
+		char *p = fe->value;
+
+		if (!strcmpx(fe->key, key)) {
+			/* We found the key */
+			key_is_filtered = true;
+			if (ignore_val)
+				goto out;
+			/*
+			 * Need to check if value in range
+			 * It can come in the following formats
+			 * (and their permutations):
+			 * numb
+			 * numb1,numb2
+			 * ,numb1,numb2
+			 * numb1-numb2
+			 * numb1,numb2-numb3,numb4-numb5
+			 */
+			while (*p) {
+				if (isdigit(*p)) {
+					fe_value = strtol(p, &p, 10);
+					if (fe_value == val ||
+					    (range_check && left_val < val &&
+					     val < fe_value)) {
+						key_is_filtered = false;
+						goto out;
+					}
+					range_check = false;
+				} else {
+					if (*p == '-') {
+						left_val = fe_value;
+						range_check = true;
+					}
+					p++;
+				}
+			}
+			goto out;
+		}
+	}
+
+out:
+	return key_is_filtered;
+}
+
+static void filters_cleanup(struct rd *rd)
+{
+	struct filter_entry *fe, *tmp;
+
+	list_for_each_entry_safe(fe, tmp,
+				 &rd->filter_list, list) {
+		list_del(&fe->list);
+		free(fe->key);
+		free(fe->value);
+		free(fe);
+	}
+}
+
 static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_DEV_INDEX] = MNL_TYPE_U32,
 	[RDMA_NLDEV_ATTR_DEV_NAME] = MNL_TYPE_NUL_STRING,
@@ -181,6 +392,7 @@ void rd_free(struct rd *rd)
 		return;
 	free(rd->buff);
 	dev_map_cleanup(rd);
+	filters_cleanup(rd);
 }
 
 int rd_exec_link(struct rd *rd, int (*cb)(struct rd *rd), bool strict_port)
-- 
2.15.1
