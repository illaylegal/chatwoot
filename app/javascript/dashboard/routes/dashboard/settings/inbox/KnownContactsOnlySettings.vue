<script setup>
import { ref, watch } from 'vue';
import { useStore } from 'vuex';
import { useI18n } from 'vue-i18n';
import { useAlert } from 'dashboard/composables';
import SettingsFieldSection from 'dashboard/components-next/Settings/SettingsFieldSection.vue';
import Switch from 'dashboard/components-next/switch/Switch.vue';

const props = defineProps({
  inbox: {
    type: Object,
    default: () => ({}),
  },
});

const store = useStore();
const { t } = useI18n();

const knownContactsOnly = ref(Boolean(props.inbox.known_contacts_only));

watch(
  () => props.inbox.known_contacts_only,
  value => {
    knownContactsOnly.value = Boolean(value);
  }
);

const saveSetting = async () => {
  try {
    await store.dispatch('inboxes/updateInbox', {
      id: props.inbox.id,
      formData: false,
      channel: { known_contacts_only: knownContactsOnly.value },
    });
    useAlert(t('INBOX_MGMT.KNOWN_CONTACTS_ONLY.SUCCESS_MESSAGE'));
  } catch (error) {
    knownContactsOnly.value = Boolean(props.inbox.known_contacts_only);
    useAlert(t('INBOX_MGMT.KNOWN_CONTACTS_ONLY.ERROR_MESSAGE'));
  }
};
</script>

<template>
  <SettingsFieldSection
    :label="$t('INBOX_MGMT.KNOWN_CONTACTS_ONLY.TITLE')"
    :help-text="$t('INBOX_MGMT.KNOWN_CONTACTS_ONLY.HELP_TEXT')"
    class="mb-4"
  >
    <div class="flex items-center gap-2">
      <Switch v-model="knownContactsOnly" @change="saveSetting" />
      <span class="text-body-para text-n-slate-12">
        {{ $t('INBOX_MGMT.KNOWN_CONTACTS_ONLY.TOGGLE_LABEL') }}
      </span>
    </div>
  </SettingsFieldSection>
</template>
